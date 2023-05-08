(use-package nxml-mode
  :straight (:type built-in)
  :mode (("\\.xml\\'" . nxml-mode)
         ("\\.rss\\'" . nxml-mode))
  :custom
  (nxml-slash-auto-complete-flag t)
  (nxml-auto-insert-xml-declaration-flag t))

(use-package toml-mode
  :mode (("\\.toml$" . toml-mode)))

(use-package yaml-mode
  :mode "\\.yml\\'"
  :init
  (setq yaml-indent-offset 2))

(use-package dockerfile-mode
  :mode "\\Dockerfile\\'")

(use-package lua-mode
  :mode "\\.lua$"
  :init
  (setq lua-indent-level 2))

(use-package yasnippet
  :diminish yas-minor-mode
  :hook (prog-mode . yas-minor-mode)
  :custom
  (yas-use-menu nil)
  :config
  (setq yas-inhibit-overlay-modification-protection t)
  (advice-add 'yas--on-protection-overlay-modification :override #'ignore)
  (use-package yasnippet-snippets))

(provide 'init-prog)
