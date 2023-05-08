(use-package vterm
  :defer t
  :init
  (setq vterm-always-compile-module t))

(use-package vterm-toggle
  :defer t
  :bind
  ([f9] . 'vterm-toggle))

(provide 'init-shell)
