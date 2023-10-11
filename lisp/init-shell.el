;; @see https://github.com/akermu/emacs-libvterm#installation
(when (and module-file-suffix           ; dynamic module
           (executable-find "cmake")
           (executable-find "libtool")  ; libtool-bin
           (executable-find "make"))
  (use-package vterm
    :init (setq vterm-always-compile-module t)
    :bind (:map vterm-mode-map
                ("<f10>" . multi-vterm-dedicated-toggle)
                ("<f9>" . multi-vterm-project)))

  (use-package multi-vterm
    :bind (("<f10>" . multi-vterm-dedicated-toggle)
           ("<f9>" . multi-vterm-project))
    :custom (multi-vterm-buffer-name "vterm")
    ))

(provide 'init-shell)
