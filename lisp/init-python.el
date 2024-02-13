(use-package python
  :straight (:type built-in)
  :mode ("\\.py\\'" . python-mode)
  :init
  (setq python-indent-offset 4
        python-fill-docstring-style 'django
        python-indent-guess-indent-offset nil
        python-shell-completion-native-enable nil))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))) 

(provide 'init-python)
