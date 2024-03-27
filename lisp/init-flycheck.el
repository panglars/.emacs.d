
(use-package flycheck
  :defer t
  :commands flycheck-redefine-standard-error-levels
  :hook (after-init . global-flycheck-mode)
  :init
  (setq flycheck-global-modes '(not outline-mode fundamental-mode lisp-interaction-mode diff-mode shell-mode eshell-mode term-mode vterm-mode)
        flycheck-emacs-lisp-load-path 'inherit
        flycheck-display-errors-delay 0.25
        flycheck-highlighting-mode 'symbols
        flycheck-indication-mode (if (display-graphic-p) 'left-fringe 'left-margin)
        ;; Only check while saving and opening files
        flycheck-check-syntax-automatically '(save mode-enabled))
  (setq-default flycheck-disabled-checkers '(emacs-lisp emacs-lisp-checkdoc))
  ;; :config
  ;; Prettify indication styles
  ;;  (when (fboundp 'define-fringe-bitmap)
  ;;    (define-fringe-bitmap 'flycheck-fringe-bitmap-arrow
  ;;      [16 48 112 240 112 48 16] nil nil 'center))

  (use-package flycheck-posframe
    :disabled
    :if (display-graphic-p)
    :custom-face
    (flycheck-posframe-face ((t (:foreground ,(face-foreground 'success)))))
    (flycheck-posframe-info-face ((t (:foreground ,(face-foreground 'success)))))
    (flycheck-posframe-background-face ((t (:inherit tooltip))))
    (flycheck-posframe-border-face ((t (:inherit font-lock-comment-face))))
    :hook (flycheck-mode . flycheck-posframe-mode)
    :config
    ;;    (setq flycheck-posframe-border-width 1)
    (setq flycheck-posframe-position 'window-bottom-left-corner)
    ))

(use-package xref
  :straight (:type built-in)
  :hook ((xref-after-return xref-after-jump) . recenter)
  :custom
  (xref-search-program (cond ((executable-find "rg") 'ripgrep)
                             ((executable-find "ugrep") 'ugrep)
                             (t 'grep)))
  )
(provide 'init-flycheck)
