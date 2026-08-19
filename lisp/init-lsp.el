;;; init-lsp.el --- -*- lexical-binding:t; -*-

;;;; Eglot
(use-package eglot
  :straight (:type built-in)
  :hook (((c-mode c-ts-mode
                  c++-mode c++-ts-mode
                  clojure-mode
                  python-mode python-ts-mode
                  rust-mode rust-ts-mode
                  js-mode js-ts-mode
                  typescript-mode typescript-ts-mode tsx-ts-mode
                  astro-mode
                  typst-ts-mode)
          . eglot-ensure))
  :init
  (setq eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5)
  :config
  (add-to-list 'eglot-server-programs
               '(astro-mode . ("astro-ls" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(typst-ts-mode . ("tinymist" "lsp")))

  ;; rust-analyzer extensions
  (use-package eglot-x
    :straight (:host github :repo "nemethf/eglot-x")
    :config
    (eglot-x-setup))

  (use-package consult-eglot
    :bind (:map eglot-mode-map
                ("C-M-." . consult-eglot-symbols))))

(provide 'init-lsp)
;;; init-lsp.el ends here
