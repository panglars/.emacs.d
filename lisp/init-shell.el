(use-package vterm
  :init
  (setq vterm-always-compile-module t))

(use-package vterm-toggle
  :bind
  ([f9] . 'vterm-toggle)
  ([C-f9] . 'vterm-toggle-cd))

(provide 'init-shell)
