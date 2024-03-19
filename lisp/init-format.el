(use-package apheleia
  :config
  (apheleia-global-mode +1))

(use-package aggressive-indent-mode
  :defer t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package header2
  :disabled
  :load-path (lambda () (expand-file-name "site-lisp/header2" user-emacs-directory))
  :custom
  (header-copyright-notice (concat "Copyright (C) 2023 " (user-full-name) "\n"))
  :hook (emacs-lisp-mode . auto-make-header)
  :config
  (add-to-list 'write-file-functions 'auto-update-file-header)
  (autoload 'auto-make-header "header2")
  (autoload 'auto-update-file-header "header2"))

(provide 'init-format)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-format.el ends here
