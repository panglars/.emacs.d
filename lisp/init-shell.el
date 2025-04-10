;; @see https://github.com/akermu/emacs-libvterm#installation
(when (and module-file-suffix           ; dynamic module
           (executable-find "cmake")
           (executable-find "libtool")  ; libtool-bin
           (executable-find "make"))
  (use-package vterm
    :init (setq vterm-always-compile-module t)
    :bind (:map vterm-mode-map
                ("<f10>" . vterm-toggle)
                ("C-\\" . toggle-input-method)
                ("C-q" . vterm-send-next-key)
                ([(control return)] . vterm-toggle-insert-cd))
    :config
    (defvar meow-vterm-normal-mode-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "RET") #'vterm-send-return)
        map)
      "Keymap for vterm in normal mode.")

    (defun meow-vterm-insert-enter ()
      "Enable vterm default binding in insert and set cursor."
      (use-local-map vterm-mode-map)
      (vterm-goto-char (point)))

    (defun meow-vterm-insert-exit ()
      "Use regular bindings in normal mode."
      (use-local-map meow-vterm-normal-mode-map))

    (defun meow-vterm-setup ()
      "Configure insert mode for vterm."
      (add-hook 'meow-insert-enter-hook #'meow-vterm-insert-enter nil t)
      (add-hook 'meow-insert-exit-hook #'meow-vterm-insert-exit nil t)
      (use-local-map meow-vterm-normal-mode-map))

;;;###autoload
    (defun meow-vterm-enable ()
      "Enable syncing vterm keymap with current meow mode."
      (setq vterm-keymap-exceptions '("C-c"))
      (define-key vterm-mode-map (kbd "C-c ESC") #'vterm-send-escape)
      (dolist (c '((yank . vterm-yank)
                   (xterm-paste . vterm-xterm-paste)
                   (yank-pop . vterm-yank-pop)
                   (mouse-yank-primary . vterm-yank-primary)
                   (self-insert-command . vterm--self-insert)
                   (beginning-of-defun . vterm-previous-prompt)
                   (end-of-defun . vterm-next-prompt)))
        (define-key meow-vterm-normal-mode-map (vector 'remap (car c)) (cdr c)))
      (add-hook 'vterm-mode-hook #'meow-vterm-setup))
    (meow-vterm-enable)
    )
  (use-package vterm-toggle
    :bind (("<f10>" . vterm-toggle)))
  )

(provide 'init-shell)
