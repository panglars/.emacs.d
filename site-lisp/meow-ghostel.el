;;; meow-ghostel.el --- Meow integration for ghostel -*- lexical-binding: t; -*-

;;; Code:

(require 'cl-lib)
(require 'ghostel)
(require 'meow)

(declare-function ghostel--cursor-position "ghostel-module")
(declare-function ghostel--mode-enabled "ghostel-module")

(defvar meow-ghostel-mode)

;; ---------------------------------------------------------------------------
;; Customization
;; ---------------------------------------------------------------------------

(defgroup meow-ghostel nil
  "Meow integration for ghostel."
  :group 'ghostel
  :prefix "meow-ghostel-")

;; (defun meow-ghostel--set-initial-state (state)
;;   "Register STATE as the initial Meow state for `ghostel-mode'."
;;   (setq meow-mode-state-list
;;         (assq-delete-all 'ghostel-mode meow-mode-state-list))
;;   (add-to-list 'meow-mode-state-list (cons 'ghostel-mode state)))

;; (defcustom meow-ghostel-initial-state 'insert
;;   "Initial Meow state for new `ghostel-mode' buffers.
;; Setting this option via `customize-set-variable', `setopt', or the
;; Customize UI updates `meow-mode-state-list' immediately."
;;   :type '(choice (const :tag "Insert" insert)
;;                  (const :tag "Normal" normal)
;;                  (const :tag "Motion" motion)
;;                  (symbol :tag "Other state"))
;;   :set (lambda (sym val)
;;          (set-default-toplevel-value sym val)
;;          (meow-ghostel--set-initial-state val)))

(defcustom meow-ghostel-escape 'auto
  "Where insert-state ESC is routed in ghostel buffers.

`auto'      means ESC is sent to the terminal in alt-screen mode
              (DECSET 1049, used by vim, less, htop, nvim, etc.);
              otherwise Meow handles ESC and enters normal state.
`terminal'  means always send ESC to the terminal.
`meow'      means always let Meow handle ESC.

Sets the initial value of the buffer-local state.  Use
\\[meow-ghostel-toggle-send-escape] to change it for the current buffer."
  :type '(choice (const :tag "Auto (alt-screen heuristic)" auto)
                 (const :tag "Always to terminal" terminal)
                 (const :tag "Always to Meow" meow)))

(defvar-local meow-ghostel--escape-mode nil
  "Buffer-local override for ESC routing.
Initialized from `meow-ghostel-escape' when the minor mode turns on.
Valid values are `auto', `terminal', and `meow'.")

;; Apply the current value at load.  Covers plain `setq' before loading.
;; (meow-ghostel--set-initial-state meow-ghostel-initial-state)

;; ---------------------------------------------------------------------------
;; Guard predicates
;; ---------------------------------------------------------------------------

(defun meow-ghostel--alt-screen-p ()
  "Return non-nil when the terminal is in alt-screen mode."
  (and ghostel--term
       (ghostel--mode-enabled ghostel--term 1049)))

(defun meow-ghostel--active-p ()
  "Return non-nil when meow-ghostel editing should intercept."
  (and (meow-ghostel--intercept-p)
       ghostel--term))

(defun meow-ghostel--intercept-p ()
  "Return non-nil when commands should not fall back to buffer editing."
  (and meow-ghostel-mode
       (bound-and-true-p meow-mode)
       (derived-mode-p 'ghostel-mode)
       (not (meow-ghostel--alt-screen-p))
       (not ghostel--copy-mode-active)))

;; ---------------------------------------------------------------------------
;; Cursor synchronization
;; ---------------------------------------------------------------------------

(defun meow-ghostel--scrollback-lines ()
  "Return the number of scrollback lines before the live viewport."
  (if ghostel--term-rows
      (max 0 (- (count-lines (point-min) (point-max))
                ghostel--term-rows))
    0))

(defun meow-ghostel--reset-cursor-point ()
  "Move Emacs point to the terminal cursor position."
  (when (and ghostel--term ghostel--term-rows)
    (let ((pos (ghostel--cursor-position ghostel--term)))
      (when pos
        (goto-char (point-min))
        (forward-line (+ (meow-ghostel--scrollback-lines) (cdr pos)))
        (move-to-column (car pos))))))

(defun meow-ghostel--viewport-row-at-point ()
  "Return the live-viewport row containing point."
  (- (line-number-at-pos (point) t)
     1
     (meow-ghostel--scrollback-lines)))

(defun meow-ghostel--cursor-to-point ()
  "Move the terminal cursor to Emacs point by sending arrow keys."
  (when ghostel--term
    (let* ((tpos (ghostel--cursor-position ghostel--term))
           (tcol (car tpos))
           (trow (cdr tpos))
           (ecol (current-column))
           (erow (meow-ghostel--viewport-row-at-point))
           (dy (- erow trow))
           (dx (- ecol tcol)))
      (cond ((> dy 0) (dotimes (_ dy) (ghostel--send-encoded "down" "")))
            ((< dy 0) (dotimes (_ (abs dy)) (ghostel--send-encoded "up" ""))))
      (cond ((> dx 0) (dotimes (_ dx) (ghostel--send-encoded "right" "")))
            ((< dx 0) (dotimes (_ (abs dx)) (ghostel--send-encoded "left" "")))))))

(defvar meow-ghostel--sync-inhibit nil
  "When non-nil, skip arrow-key sync on next insert-state entry.")

(defun meow-ghostel--insert-state-entry ()
  "Sync terminal cursor to Emacs point when entering Meow insert state."
  (when (derived-mode-p 'ghostel-mode)
    (if meow-ghostel--sync-inhibit
        (setq meow-ghostel--sync-inhibit nil)
      (when (meow-ghostel--active-p)
        (let* ((tpos (ghostel--cursor-position ghostel--term))
               (trow (cdr tpos))
               (erow (meow-ghostel--viewport-row-at-point)))
          (if (= erow trow)
              (meow-ghostel--cursor-to-point)
            (meow-ghostel--reset-cursor-point)))))))

;; ---------------------------------------------------------------------------
;; Redraw and cursor style
;; ---------------------------------------------------------------------------

(defun meow-ghostel--around-redraw (orig-fn term &optional full)
  "Preserve point across native redraw in non-insert Meow states.
ORIG-FN is the advised `ghostel--redraw' called with TERM and FULL."
  (if (and meow-ghostel-mode
           (bound-and-true-p meow-mode)
           (not (ghostel--mode-enabled term 1049)))
      (let* ((preserve-point (not (meow-insert-mode-p)))
             (saved-point (and preserve-point (point)))
             (saved-selection (and preserve-point meow--selection))
             (saved-history (and preserve-point meow--selection-history)))
        (funcall orig-fn term full)
        (when preserve-point
          (goto-char (min saved-point (point-max)))
          (setq meow--selection saved-selection
                meow--selection-history saved-history)))
    (funcall orig-fn term full)))

(defun meow-ghostel--override-cursor-style (orig-fn style visible)
  "Let Meow control cursor shape instead of the terminal.
ORIG-FN is the advised setter called with STYLE and VISIBLE."
  (if (and meow-ghostel-mode
           (bound-and-true-p meow-mode)
           ghostel--term
           (not (meow-ghostel--alt-screen-p)))
      (meow--update-cursor)
    (funcall orig-fn style visible)))

;; ---------------------------------------------------------------------------
;; Editing primitives
;; ---------------------------------------------------------------------------

(defun meow-ghostel--region-text (beg end)
  "Return buffer text between BEG and END without properties."
  (filter-buffer-substring beg end))

(defun meow-ghostel--save-region (beg end &optional append)
  "Save text between BEG and END to the kill ring.
When APPEND is non-nil, append to the latest kill."
  (let ((text (meow-ghostel--region-text beg end)))
    (if append
        (kill-append text nil)
      (kill-new text))))

(defun meow-ghostel--delete-region (beg end)
  "Delete text between BEG and END via the terminal PTY."
  (let ((count (- end beg)))
    (when (> count 0)
      (goto-char end)
      (meow-ghostel--cursor-to-point)
      (dotimes (_ count)
        (ghostel--send-encoded "backspace" ""))
      (goto-char beg))))

(defun meow-ghostel--line-selection-p ()
  "Return non-nil when the active Meow selection is line-oriented."
  (and (region-active-p)
       (eq (cdr (meow--selection-type)) 'line)))

(defun meow-ghostel--clear-input-line ()
  "Clear the current shell input line."
  (ghostel--send-encoded "e" "ctrl")
  (ghostel--send-encoded "u" "ctrl"))

(defun meow-ghostel--kill-line ()
  "Kill from point to end of line through the terminal."
  (let ((end (line-end-position)))
    (when (< (point) end)
      (meow-ghostel--save-region (point) end)))
  (meow-ghostel--cursor-to-point)
  (ghostel--send-encoded "k" "ctrl"))

(defun meow-ghostel--delete-active-region (&optional save append)
  "Delete the active region via the PTY.
When SAVE is non-nil, put the region in the kill ring.  When APPEND
is non-nil, append it to the latest kill."
  (let ((beg (region-beginning))
        (end (region-end)))
    (when save
      (meow-ghostel--save-region beg end append))
    (if (meow-ghostel--line-selection-p)
        (meow-ghostel--clear-input-line)
      (meow-ghostel--delete-region beg end))
    (meow--cancel-selection)))

;; ---------------------------------------------------------------------------
;; Meow command advice
;; ---------------------------------------------------------------------------

(defun meow-ghostel--around-insert-exit (orig-fn &rest args)
  "Route insert-state ESC between Meow and the terminal.
ORIG-FN is the advised `meow-insert-exit' called with ARGS."
  (let* ((mode meow-ghostel--escape-mode)
         (to-terminal (and meow-ghostel-mode
                           ghostel--term
                           (or (eq mode 'terminal)
                               (and (eq mode 'auto)
                                    (meow-ghostel--alt-screen-p))))))
    (if to-terminal
        (progn
          (ghostel--snap-to-input)
          (ghostel--send-encoded "escape" ""))
      (when (and meow-ghostel-mode
                 ghostel--term
                 (not (meow-ghostel--alt-screen-p)))
        (meow-ghostel--reset-cursor-point))
      (apply orig-fn args))))

(defun meow-ghostel--around-delete-char (orig-fn &rest args)
  "Intercept `meow-C-d' and aliases in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (when (< (point) (point-max))
        (meow-ghostel--delete-region (point) (1+ (point))))
    (apply orig-fn args)))

(defun meow-ghostel--around-backspace (orig-fn &rest args)
  "Intercept `meow-backspace' and aliases in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (when (> (point) (point-min))
        (meow-ghostel--cursor-to-point)
        (ghostel--send-encoded "backspace" "")
        (backward-char 1))
    (apply orig-fn args)))

(defun meow-ghostel--around-kill-line (orig-fn &rest args)
  "Intercept `meow-C-k' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (meow-ghostel--kill-line)
    (apply orig-fn args)))

(defun meow-ghostel--around-kill (orig-fn &rest args)
  "Intercept `meow-kill' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (if (region-active-p)
          (meow-ghostel--delete-active-region t)
        (apply orig-fn args))
    (apply orig-fn args)))

(defun meow-ghostel--around-kill-append (orig-fn &rest args)
  "Intercept `meow-kill-append' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (if (region-active-p)
          (meow-ghostel--delete-active-region t t)
        (apply orig-fn args))
    (apply orig-fn args)))

(defun meow-ghostel--around-change (orig-fn &rest args)
  "Intercept `meow-change' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (if (region-active-p)
          (progn
            (meow-ghostel--delete-active-region nil)
            (setq meow-ghostel--sync-inhibit t)
            (meow--switch-state 'insert)
            (setq-local meow--insert-pos (point))
            (when meow-select-on-change
              (setq-local meow--insert-activate-mark t)))
        (meow-change-char))
    (apply orig-fn args)))

(defun meow-ghostel--around-change-char (orig-fn &rest args)
  "Intercept `meow-change-char' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (when (< (point) (point-max))
        (meow-ghostel--delete-region (point) (1+ (point)))
        (setq meow-ghostel--sync-inhibit t)
        (meow--switch-state 'insert)
        (setq-local meow--insert-pos (point))
        (when meow-select-on-change
          (setq-local meow--insert-activate-mark t)))
    (apply orig-fn args)))

(defun meow-ghostel--around-replace (orig-fn &rest args)
  "Intercept `meow-replace' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (let ((text (current-kill 0 t)))
        (when text
          (if (region-active-p)
              (meow-ghostel--delete-active-region nil)
            (meow-ghostel--delete-region (point) (min (point-max) (1+ (point)))))
          (set-marker meow--replace-start-marker (point))
          (ghostel--paste-text (string-trim-right text "\n"))))
    (apply orig-fn args)))

(defun meow-ghostel--around-yank (orig-fn &rest args)
  "Intercept `meow-yank' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--active-p)
      (let ((text (current-kill 0 t)))
        (when text
          (meow-ghostel--cursor-to-point)
          (ghostel--paste-text text)))
    (apply orig-fn args)))

(defun meow-ghostel--around-undo (orig-fn &rest args)
  "Intercept `meow-undo' in ghostel buffers.
ORIG-FN is the original command called with ARGS."
  (if (meow-ghostel--intercept-p)
      (ghostel--send-encoded "_" "ctrl")
    (apply orig-fn args)))

;; ---------------------------------------------------------------------------
;; ESC routing
;; ---------------------------------------------------------------------------

(defconst meow-ghostel--escape-modes '(auto terminal meow)
  "Cycle order for `meow-ghostel-toggle-send-escape'.")

(defun meow-ghostel-toggle-send-escape (&optional arg)
  "Cycle or set ESC routing for the current buffer.
Without ARG, cycle through `auto' -> `terminal' -> `meow' -> `auto'.
With numeric prefix 1, set to `auto'; 2 to `terminal'; 3 to `meow'."
  (interactive "P")
  (let ((target
         (if arg
             (let ((n (prefix-numeric-value arg)))
               (or (nth (1- n) meow-ghostel--escape-modes)
                   (user-error
                    "Invalid prefix %d; use 1 (auto), 2 (terminal), or 3 (meow)"
                    n)))
           (let ((next (cdr (memq meow-ghostel--escape-mode
                                  meow-ghostel--escape-modes))))
             (or (car next) (car meow-ghostel--escape-modes))))))
    (setq meow-ghostel--escape-mode target)
    (message "meow-ghostel ESC mode: %s" target)))

;; ---------------------------------------------------------------------------
;; Minor mode
;; ---------------------------------------------------------------------------

;;;###autoload
(define-minor-mode meow-ghostel-mode
  "Minor mode for Meow integration in ghostel terminal buffers."
  :lighter nil
  (if meow-ghostel-mode
      (progn
        (setq meow-ghostel--escape-mode meow-ghostel-escape)
        (add-hook 'meow-insert-enter-hook
                  #'meow-ghostel--insert-state-entry nil t)
        (advice-add 'meow-insert-exit :around #'meow-ghostel--around-insert-exit)
        (advice-add 'meow-C-d :around #'meow-ghostel--around-delete-char)
        (advice-add 'meow-delete :around #'meow-ghostel--around-delete-char)
        (advice-add 'meow-backspace :around #'meow-ghostel--around-backspace)
        (advice-add 'meow-backward-delete :around #'meow-ghostel--around-backspace)
        (advice-add 'meow-C-k :around #'meow-ghostel--around-kill-line)
        (advice-add 'meow-kill :around #'meow-ghostel--around-kill)
        (advice-add 'meow-kill-append :around #'meow-ghostel--around-kill-append)
        (advice-add 'meow-change :around #'meow-ghostel--around-change)
        (advice-add 'meow-change-char :around #'meow-ghostel--around-change-char)
        (advice-add 'meow-replace :around #'meow-ghostel--around-replace)
        (advice-add 'meow-replace-char :around #'meow-ghostel--around-replace)
        (advice-add 'meow-yank :around #'meow-ghostel--around-yank)
        (advice-add 'meow-undo :around #'meow-ghostel--around-undo)
        (advice-add 'meow-undo-in-selection :around #'meow-ghostel--around-undo)
        (advice-add 'ghostel--redraw :around #'meow-ghostel--around-redraw)
        (advice-add 'ghostel--set-cursor-style :around
                    #'meow-ghostel--override-cursor-style))
    (remove-hook 'meow-insert-enter-hook
                 #'meow-ghostel--insert-state-entry t)
    (advice-remove 'meow-insert-exit #'meow-ghostel--around-insert-exit)
    (advice-remove 'meow-C-d #'meow-ghostel--around-delete-char)
    (advice-remove 'meow-delete #'meow-ghostel--around-delete-char)
    (advice-remove 'meow-backspace #'meow-ghostel--around-backspace)
    (advice-remove 'meow-backward-delete #'meow-ghostel--around-backspace)
    (advice-remove 'meow-C-k #'meow-ghostel--around-kill-line)
    (advice-remove 'meow-kill #'meow-ghostel--around-kill)
    (advice-remove 'meow-kill-append #'meow-ghostel--around-kill-append)
    (advice-remove 'meow-change #'meow-ghostel--around-change)
    (advice-remove 'meow-change-char #'meow-ghostel--around-change-char)
    (advice-remove 'meow-replace #'meow-ghostel--around-replace)
    (advice-remove 'meow-replace-char #'meow-ghostel--around-replace)
    (advice-remove 'meow-yank #'meow-ghostel--around-yank)
    (advice-remove 'meow-undo #'meow-ghostel--around-undo)
    (advice-remove 'meow-undo-in-selection #'meow-ghostel--around-undo)
    (advice-remove 'ghostel--redraw #'meow-ghostel--around-redraw)
    (advice-remove 'ghostel--set-cursor-style
                   #'meow-ghostel--override-cursor-style)))

(provide 'meow-ghostel)
;;; meow-ghostel.el ends here
