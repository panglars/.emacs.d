;; CSS
;; (use-package css-mode
;;   :init (setq css-indent-offset 2))

;; Major mode for editing web templates
(use-package web-mode
  :mode "\\.\\(phtml\\|php\\|[gj]sp\\|as[cp]x\\|erb\\|djhtml\\|html?\\|hbs\\|ejs\\|jade\\|swig\\|tm?pl\\|vue\\|astro\\)$"
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

;; Adds node_modules/.bin directory to `exec_path'
(use-package add-node-modules-path
  :hook ((web-mode js-mode js2-mode) . add-node-modules-path))

(use-package restclient
  :disabled
  :mode ("\\.http\\'" . restclient-mode)
  :config
  (use-package restclient-test
    :diminish
    :hook (restclient-mode . restclient-test-mode)))

(use-package rainbow-mode)

(use-package prisma-mode
  :disabled
  :straight (:host github :repo "pimeys/emacs-prisma-mode"))

(use-package tsx-ts-helper-mode
  :straight (tsx-ts-helper-mode
             :type git
             :host codeberg
             :repo "ckruse/tsx-ts-helper-mode")
  :commands (tsx-ts-helper-mode)
  :custom (tsx-ts-helper-mode-keymap-prefix (kbd "C-c C-t"))
  :hook (tsx-ts-mode . tsx-ts-helper-mode))


(use-package jsdoc
  :straight (:host github :repo "isamert/jsdoc.el"))



(provide 'init-web)
