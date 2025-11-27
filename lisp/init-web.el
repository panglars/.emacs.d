;; -*- lexical-binding: t; -*-

;; Major mode for editing web templates
(use-package web-mode
  :mode "\\.\\(phtml\\|php\\|[gj]sp\\|as[cp]x\\|erb\\|djhtml\\|html?\\|hbs\\|ejs\\|jade\\|swig\\|tm?pl\\|vue\\|astro\\)$"
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  ;; ASTRO
  (define-derived-mode astro-mode web-mode "astro")
  )

;; Adds node_modules/.bin directory to `exec_path'
(use-package add-node-modules-path
  :disabled
  :hook ((web-mode js-mode js2-mode) . add-node-modules-path))

(use-package restclient
  :disabled
  :mode ("\\.http\\'" . restclient-mode)
  :config
  (use-package restclient-test
    :diminish
    :hook (restclient-mode . restclient-test-mode)))

;; Insert JSDoc comments
(use-package jsdoc
  :disabled
  :straight (:host github :repo "isamert/jsdoc.el"))



(provide 'init-web)
