;; @see https://github.com/akermu/emacs-libvterm#installation
(when (and module-file-suffix           ; dynamic module
           (executable-find "cmake")
           (executable-find "libtool")  ; libtool-bin
           (executable-find "make"))
  (use-package vterm
    :init (setq vterm-always-compile-module t)
    :bind (:map vterm-mode-map
                ("<f10>" . vterm-toggle)
                ([(control return)] . vterm-toggle-insert-cd)))
  (use-package vterm-toggle
    :bind (("<f10>" . vterm-toggle)))
  )

(provide 'init-shell)
