;;; init-core.el ---Base setting after load -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package benchmark-init
  :demand t
  :config
  (require 'benchmark-init-modes)
  (add-hook 'after-init-hook #'benchmark-init/deactivate))

                                        ; Don't litter emacs directory
(use-package no-littering
  :init
  (setq no-littering-etc-directory (expand-file-name "etc/" my-cache-dir)
        no-littering-var-directory (expand-file-name "var/" my-cache-dir)))

;; pop up a frame at point
(use-package popup)
(use-package posframe)
(use-package diminish)

(use-package display-line-numbers
  :straight (:type built-in)
  :init
  ;; (add-hook 'text-mode-hook #'display-line-numbers-mode)
  ;;  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (setq display-line-numbers-width 4
        display-line-numbers-widen t
        ;; display-line-numbers-type 'relative
        display-line-numbers-current-absolute t))

;; an aesthetic plugin designed to visually distinguish "real" buffers
;;(use-package solaire-mode)

;;; theme
;; (use-package doom-themes)
(use-package modus-themes)
;; (use-package kaolin-themes)
(use-package ef-themes)

;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions (lambda (frame) (load-theme 'modus-operandi-tinted t)))
;;   (load-theme 'doom-moonlight t))

(use-package auto-dark
  :config 
  (setq auto-dark-dark-theme 'ef-dream)
  (setq auto-dark-light-theme 'ef-reverie)
  ;; (setq auto-dark-detection-method nil) ;; dangerous to be set manually
  (auto-dark-mode t))

;; transparent background
(setq default-frame-alist '((width . 120)
                            (height . 80)
                            (alpha-background . 99)
                            ))
(when (display-graphic-p)
  ;; Frame maximized
  (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

(use-package nerd-icons)

(modify-all-frames-parameters
 '((right-divider-width . 5)
   (left-divider-width . 5)
   (internal-border-width . 5)))
(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))


(use-package which-key
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.2
        which-key-compute-remaps t
        which-key-min-display-lines 1
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-sort-uppercase-first nil
        which-key-side-window-max-width 0.4
        which-key-side-window-max-height 0.4
        which-key-sort-order #'which-key-prefix-then-key-order)
  (which-key-setup-side-window-bottom)
  (dolist (item '((("SPC" . nil) . ("␣" . nil))
                  (("TAB" . nil) . ("↹" . nil))
                  (("RET" . nil) . ("⏎" . nil))
                  (("DEL" . nil) . ("⌫" . nil))
                  (("<up>" . nil) . ("↑" . nil))
                  (("<down>" . nil) . ("↓" . nil))
                  (("<left>" . nil) . ("←" . nil))
                  (("<right>" . nil) . ("→" . nil))
                  (("deletechar" . nil) . ("⌦" . nil))
                  ;; rename winum-select-window-1 entry to 1..9
                  (("\\(.*\\)1" . "winum-select-window-1") . ("\\11..9" . "window 1..9"))
                  ;; hide winum-select-window-[2-9] entries
                  ((nil . "winum-select-window-[2-9]") . t)))
    (cl-pushnew item which-key-replacement-alist :test #'equal))
  (set-face-attribute 'which-key-local-map-description-face nil :weight 'bold))

(use-package bookmark
  :defer t
  :straight (:type built-in))

(use-package elec-pair
  :straight (:type built-in)
  :hook (after-init . electric-pair-mode)
  :config
  (setq electric-pair-inhibit-predicate (lambda (char) (minibufferp))))


(use-package sudo-edit)

(use-package eldoc
  :straight (:type built-in)
  :bind (("C-c e" . eldoc-print-current-symbol-info))
  :custom
  (eldoc-documentation-strategy #'eldoc-documentation-compose)
  :config
  (setq eldoc-echo-area-display-truncation-message t
        eldoc-echo-area-prefer-doc-buffer t
        eldoc-echo-area-use-multiline-p nil
        eglot-extend-to-xref t)
  
  ;;  displays ElDoc documentations in a childframe
  (use-package eldoc-box)
  )




(provide 'init-core)
