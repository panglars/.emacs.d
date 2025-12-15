;; -*- lexical-binding: t; -*-
(use-package page-break-lines
  :config
  (set-fontset-font "fontset-default"
                    (cons page-break-lines-char page-break-lines-char)
                    "CMU Typewriter Text")
  )

(use-package dashboard
  :diminish (dashboard-mode page-break-lines-mode)
  :hook (dashboard-mode . (lambda ()
                            ;; No title
                            (setq-local frame-title-format nil)
                            (when (fboundp 'page-break-lines-mode)(page-break-lines-mode 1))
                            ))
  :bind (("<f2>" . dashboard-open)
         :map dashboard-mode-map
         (("n" . dashboard-next-line)
          ("N" . dashboard-next-section)
          ("p" . dashboard-previous-line)
          ("F" . dashboard-previous-section)
          ("o" . dashboard-jump-to-projects)))
  :init
  (setq
   dashboard-center-content t
   dashboard-set-file-icons t
   dashboard-set-heading-icons t
   ;; dashboard-set-footer t
   dashboard-set-navigator t
   dashboard-page-separator "\n"
   dashboard-set-init-info t
   ;; dashboard-startup-banner "~/.emacs.d/logo_umu.svg"
   dashboard-startup-banner 'logo
   dashboard-projects-backend 'projectile
   dashboard-items '((recents . 10)
                     (projects . 5)
                     (bookmarks . 5)))
  (setq dashboard-startupify-list '(dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline
                                    dashboard-insert-footer))
  (dashboard-setup-startup-hook))

;; TODO add load-session

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-window-width-limit 100
        doom-modeline-minor-modes nil
        doom-modeline-buffer-encoding nil
        doom-modeline-position-column-line-format '("L%l:C%c")))

(use-package hide-mode-line
  :hook (((eshell-mode shell-mode
                       term-mode
                       lsp-ui-imenu-mode
                       pdf-annot-list-mode) . hide-mode-line-mode)))

(use-package tab-bar
  :straight (:type built-in)
  :hook (after-init . tab-bar-mode)
  
  :bind (("C-c n n" . tab-new)
         ("C-c n x" . tab-close)
         ("C-c n b" . consult-buffer-other-tab)
         ("C-c n 1" . tab-close-other)
         ("C-c n r" . tab-rename))
  
  :config
  (setq tab-bar-separator " "
        tab-bar-border nil
        tab-bar-history-buttons-show nil
        tab-bar-auto-width nil
        tab-bar-close-button-show nil
        tab-bar-tab-name-truncated-max 20
        tab-bar-tab-hints t)
  (setq tab-bar-format '(tab-bar-format-menu-bar meow-indicator tab-bar-format-tabs tab-bar-separator))
  (setq tab-bar-tab-name-format-function
        (lambda (tab i)
          (let ((face (funcall tab-bar-tab-face-function tab)))
            (concat
             (propertize " " 'face face)
             (propertize (number-to-string i) 'face `(:inherit ,face :weight ultra-bold :underline t))
             (propertize (concat " " (alist-get 'name tab) " ") 'face face)))))
  )

(use-package tab-line
  :disabled
  :straight (:type built-in)
  :config
  (global-tab-line-mode 1)
  (setq
   tab-line-new-button-show nil
   tab-line-close-button-show nil))


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
  (setq rainbow-delimiters-max-face-count 8))

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

(provide 'init-ui)
