(use-package copilot
  :defer t
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("C-j" . copilot-accept-completion)
              ("M-j" . copilot-clear-overlay)
              ("C-c j n" . copilot-next-completion)
              ("C-c j p" . copilot-previous-completion))
  :init
  (setq copilot--indent-warning-printed-p t)
  )

(use-package gptel
  :config
  (setq gptel-default-mode 'org-mode
        gptel-model "gpt-4-1106-preview"
        gptel-stream t)
  (defvar gptel-quick--history nil)
  (defun gptel-quick (prompt)
    (interactive (list (read-string "Ask ChatGPT: " nil gptel-quick--history)))
    (when (string= prompt "") (user-error "A prompt is required."))
    (gptel-request
     prompt
     :callback
     (lambda (response info)
       (if (not response)
           (message "gptel-quick failed with message: %s" (plist-get info :status))
         (with-current-buffer (get-buffer-create "*gptel-quick*")
           (let ((inhibit-read-only t))
             (erase-buffer)
             (insert response))
           (special-mode)
           (display-buffer (current-buffer)
                           `((display-buffer-in-side-window)
                             (side . bottom)
                             (window-height . ,#'fit-window-to-buffer))))))))

  (defun gptel-rewrite-and-replace (bounds &optional directive)
    (interactive
     (list
      (cond
       ((use-region-p) (cons (region-beginning) (region-end)))
       ((derived-mode-p 'text-mode)
        (list (bounds-of-thing-at-point 'sentence)))
       (t (cons (line-beginning-position) (line-end-position))))
      (and current-prefix-arg
           (read-string "ChatGPT Directive: "
                        "You are a prose editor. Rewrite my prompt more professionally."))))
    (gptel-request
     (buffer-substring-no-properties (car bounds) (cdr bounds)) ;the prompt
     :system (or directive "You are a prose editor. Rewrite my prompt more professionally.")
     :buffer (current-buffer)
     :context (cons (set-marker (make-marker) (car bounds))
                    (set-marker (make-marker) (cdr bounds)))
     :callback
     (lambda (response info)
       (if (not response)
           (message "ChatGPT response failed with: %s" (plist-get info :status))
         (let* ((bounds (plist-get info :context))
                (beg (car bounds))
                (end (cdr bounds))
                (buf (plist-get info :buffer)))
           (with-current-buffer buf
             (save-excursion
               (goto-char beg)
               (kill-region beg end)
               (insert response)
               (set-marker beg nil)
               (set-marker end nil)
               (message "Rewrote line. Original line saved to kill-ring."))))))))
  :bind (
         ("C-c I" . gptel-quick)
         ("C-c i s" . gptel-send)
         ("C-c i r" . gptel-rewrite-and-replace)
         ("C-c i b" . gptel))
  )

(provide 'init-copilot)
