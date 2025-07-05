;; -*- lexical-binding: t; -*-
(use-package hl-line
  :straight (:type built-in)
  :hook ((after-init . global-hl-line-mode)
         ((dashboard-mode eshell-mode shell-mode term-mode vterm-mode) .
          (lambda () (setq-local global-hl-line-mode nil)))))

(use-package paren
  :straight (:type built-in)
  :custom-face (show-paren-match ((t (:foreground "SpringGreen3" :underline t :weight bold))))
  :config
  (setq show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t
        show-paren-context-when-offscreen t
        show-paren-delay 0.2)
  )

;; Highlight brackets according to their depth
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (setq rainbow-delimiters-max-face-count 3))

(use-package goggles
  :hook ((prog-mode text-mode) . goggles-mode))

;; Highlight TODO and similar keywords in comments and strings
(use-package hl-todo
  :bind (:map hl-todo-mode-map
              ([C-f3]    . hl-todo-occur)
              ("C-c T p" . hl-todo-previous)
              ("C-c T n" . hl-todo-next)
              ("C-c T o" . hl-todo-occur)
              ("C-c T i" . hl-todo-insert))
  :hook ((prog-mode text-mode) . hl-todo-mode)
  :init (setq hl-todo-require-punctuation t
              hl-todo-highlight-punctuation ":")
  :config
  (dolist (keyword '("BUG" "DEFECT" "ISSUE"))
    (add-to-list 'hl-todo-keyword-faces `(,keyword . "#e45649")))
  (dolist (keyword '("TRICK" "WORKAROUND"))
    (add-to-list 'hl-todo-keyword-faces `(,keyword . "#d0bf8f")))
  (dolist (keyword '("DEBUG" "STUB"))
    (add-to-list 'hl-todo-keyword-faces `(,keyword . "#7cb8bb")))
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces `(("BUG" error bold)
                                ("FIXME" error bold)
                                ("TODO" warning bold)
                                ("NOTE" success bold)
                                ("HACK" font-lock-constant-face bold)
                                ("REVIEW" font-lock-keyword-face bold)
                                ("DEPRECATED" font-lock-doc-face bold))))

;; Highlight symbols
(use-package symbol-overlay
  :diminish
  :functions (turn-off-symbol-overlay turn-on-symbol-overlay)
  :bind (("M-i" . symbol-overlay-put)
         ("M-n" . symbol-overlay-jump-next)
         ("M-p" . symbol-overlay-jump-prev)
         ("M-N" . symbol-overlay-switch-forward)
         ("M-P" . symbol-overlay-switch-backward)
         ("M-C" . symbol-overlay-remove-all)
         ([M-f3] . symbol-overlay-remove-all))
  :hook (((prog-mode yaml-mode) . symbol-overlay-mode)
         (iedit-mode            . turn-off-symbol-overlay)
         (iedit-mode-end        . turn-on-symbol-overlay))
  :init (setq symbol-overlay-idle-time 0.1)
  :config
  (with-no-warnings
    ;; Disable symbol highlighting while selecting
    (defun turn-off-symbol-overlay (&rest _)
      "Turn off symbol highlighting."
      (interactive)
      (symbol-overlay-mode -1))
    (advice-add #'set-mark :after #'turn-off-symbol-overlay)

    (defun turn-on-symbol-overlay (&rest _)
      "Turn on symbol highlighting."
      (interactive)
      (when (derived-mode-p 'prog-mode 'yaml-mode)
        (symbol-overlay-mode 1)))
    (advice-add #'deactivate-mark :after #'turn-on-symbol-overlay)))

(provide 'init-highlight)
