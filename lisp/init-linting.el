;; -*- lexical-binding: t; -*-

(use-package flycheck
  :hook ((after-init . global-flycheck-mode)
         (after-init . global-flycheck-annotate-mode))
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error))
  :custom
  (flycheck-global-modes
   '(not outline-mode fundamental-mode lisp-interaction-mode
         diff-mode shell-mode eshell-mode term-mode vterm-mode))
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-display-errors-delay 0.5)
  (flycheck-check-syntax-automatically '(save mode-enabled))
  (flycheck-annotate-current-line-style 'eol)
  (flycheck-annotate-other-lines-style 'eol)
  (flycheck-eglot-exclusive nil)
  (flycheck-lsp-exclusive t)
  :config
  (setq-default flycheck-disabled-checkers
                '(emacs-lisp-checkdoc))
  (global-flycheck-eglot-mode 1)
  (global-flycheck-lsp-mode 1))

(use-package xref
  :hook ((xref-after-return xref-after-jump) . recenter)
  :custom
  (xref-search-program (cond ((executable-find "rg") 'ripgrep)
                             ((executable-find "ugrep") 'ugrep)
                             (t 'grep)))
  )

;; formatter
(use-package apheleia
  :config
  (apheleia-global-mode +1))

(use-package aggressive-indent-mode
  :defer t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(provide 'init-linting)
