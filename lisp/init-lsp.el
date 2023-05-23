(pcase my-lsp-backend
  ('lsp-mode
   (use-package lsp-mode
     :defer t
     :custom
     (lsp-completion-provider :none)
     :init
     (defun my/lsp-mode-setup-completion ()
       (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
             '(orderless))) ;; Configure orderless
     (setq read-process-output-max (* 1024 1024)) ;; 1MB
     (setq lsp-keymap-prefix "C-c l")
     (setq lsp-signature-auto-activate nil
           lsp-headerline-breadcrumb-enable nil
           lsp-eldoc-render-all nil
           lsp-signature-render-documentation nil
           ;; rust
           lsp-rust-server 'rust-analyzer
           lsp-rust-analyzer-cargo-watch-enable nil
           ;; go
           lsp-gopls-hover-kind "NoDocumentation"
           lsp-gopls-use-placeholders t

           lsp-semantic-tokens-enable t
           lsp-progress-spinner-type 'progress-bar-filled
           lsp-enable-folding nil
           lsp-enable-symbol-highlighting nil
           lsp-enable-text-document-color nil
           lsp-enable-on-type-formatting nil)
     :hook (
            (prog-mode . (lambda ()
                           (unless (derived-mode-p 'emacs-lisp-mode 'lisp-mode 'makefile-mode)
                             (lsp-deferred))))
            (lsp-completion-mode . my/lsp-mode-setup-completion)
            (lsp-mode . lsp-enable-which-key-integration))
     :config
     (use-package lsp-ui
       :bind(("C-c u" . lsp-ui-imenu)
             :map lsp-ui-mode-map
             ("s-<return>" . lsp-ui-sideline-apply-code-actions))
       :hook (lsp-mode . lsp-ui-mode)
       :init
       (setq lsp-ui-sideline-show-diagnostics nil
             lsp-ui-sideline-ignore-duplicate t
             lsp-ui-doc-delay 0.1
             lsp-ui-doc-show-with-cursor (not (display-graphic-p))
             lsp-ui-imenu-auto-refresh 'after-save
             lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                                   ,(face-foreground 'font-lock-string-face)
                                   ,(face-foreground 'font-lock-constant-face)
                                   ,(face-foreground 'font-lock-variable-name-face))))
     (use-package dap-mode

       :bind (:map lsp-mode-map
                   ("<f5>" . dap-debug))
       :config
       ;; Enabling only some features
       (setq dap-auto-configure-features '(sessions locals controls tooltip))
       (require 'dap-node)
       (dap-node-setup) ;; Automatically installs Node debug adapter if needed
       (require 'dap-chrome)
       (dap-chrome-setup))
     )
   )
  )

(provide 'init-lsp)
;;; init-lsp.el ends here
