;;; -*- lexical-binding: t -*-

(use-package benchmark-init
  :demand t
  :config
  (require 'benchmark-init-modes)
  (add-hook 'after-init-hook #'benchmark-init/deactivate))

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

;; An aesthetic plugin designed to visually distinguish "real" buffers
;;(use-package solaire-mode)

;;; theme
;; (use-package ef-themes)
(use-package standard-themes)
(use-package modus-themes
  :init
  (modus-themes-include-derivatives-mode 1)
  :config
  (modus-themes-load-theme 'modus-operandi-tinted)
  )

;; (use-package doric-themes)

(setq default-frame-alist '((width . 120)
                            (height . 80)
                            ;; (alpha-background . 90)
                            ))


;; (when (display-graphic-p)
;;   ;; Frame maximized
;;   (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
;;   (add-to-list 'default-frame-alist '(fullscreen . maximized)))

(use-package nerd-icons)

(modify-all-frames-parameters
 '((right-divider-width . 5)
   (left-divider-width . 5)
   (internal-border-width . 0)))
(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))


(use-package which-key
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 1
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
  :config
  (add-hook 'prog-mode-hook 'electric-pair-local-mode)
  (add-hook 'conf-mode-hook 'electric-pair-local-mode)
  (setq electric-pair-inhibit-predicate (lambda (char) (minibufferp))))

(use-package sudo-edit)

(use-package eldoc
  :straight (:type built-in)
  :custom
  (eldoc-documentation-strategy #'eldoc-documentation-compose)
  :config
  (setq eldoc-echo-area-display-truncation-message t
        eldoc-echo-area-prefer-doc-buffer t
        eldoc-echo-area-use-multiline-p nil
        eglot-extend-to-xref t)

  ;;  displays ElDoc documentations in a childframe
  (use-package eldoc-box))

;; use curl insted built-in url
(use-package plz)

(use-package ssh-agency)

(use-package consult
  :bind(;; C-c bindings in `mode-specific-map'
        ("C-c M-x" . consult-mode-command)
        ("C-c b" . consult-buffer)
        ("C-c r" . consult-ripgrep)
        ("C-c j" . consult-flycheck)
        ("C-c f" . consult-fd)
        ("C-c i" . consult-imenu)
        ("C-c I" . consult-imenu-multi)
        ("C-c R" . consult-bookmark)            ;; orig. bookmark-jump
        ("C-c B" . consult-project-buffer)      ;; orig. project-switch-to-buffer
        ("C-x C-r" . consult-recent-file)
        ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
        ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
        ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
        ("M-#"   . consult-register-load)
        ("M-'"   . consult-register-store)        ;; orig. abbrev-prefix-mark (unrelated)
        ("C-M-#" . consult-register)
        ("M-y" . consult-yank-pop)                ;; orig. yank-pop
        )
  :init
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (use-package consult-flycheck)
  )

;; [consult-dir] Insert path quickly in minibuffer
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(provide 'init-core)
