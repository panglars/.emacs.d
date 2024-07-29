(use-package ibuffer
  :straight (:type built-in)
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode)
  :config
  (use-package nerd-icons-ibuffer)
  (use-package ibuffer-vc
    :disabled
    :commands (ibuffer-vc-set-filter-groups-by-vc-root)
    :custom
    (ibuffer-vc-skip-if-remote 'nil))
  
  :custom
  (ibuffer-expert t)
  (ibuffer-movement-cycle nil)
  (ibuffer-show-empty-filter-groups nil))

(provide 'init-buffer)
