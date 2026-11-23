;;; init-editing.el --- Editing and input methods -*- lexical-binding: t; -*-

;;; Modal editing

(use-package meow
  :init (meow-global-mode 1)
  :demand nil
  :config
  (require 'lan-meow (expand-file-name "site-lisp/lan-meow.el" user-emacs-directory))
  (lan/meow-setup)
  (meow-leader-define-key
   '("[" . tab-previous)
   '("]" . tab-next)
   '(";" . tab-previous)
   '("\\" . tab-next))
  (meow-normal-define-key
   '("{" . tab-previous)
   '("}" . tab-next))
  (dolist
      (state
       '(
         (telega-root-mode . motion)
         (telega-chat-mode . normal)
         (calibredb-search-mode . motion)
         (blink-search-mode . insert)
         (rcirc-mode . normal)
         (comint-mode . normal)         ; IELM
         (reb-mode . normal)            ; re-builder
         (elfeed-search-mode . motion)
         (elfeed-show-mode . motion)
         (fundamental-mode . normal)
         (message-mode . normal)
         (emacs-lisp-mode . normal)
         (eshell-mode . insert)
         (shell-mode . insert)
         (term-mode . insert)
         (help-mode . normal)
         (helpful-mode . normal)
         (subed-mode . motion)
         (vundo-mode . motion)
         (autoscratch-mode . insert)
         (lsp-bridge-ref-mode . motion)
         ))
    (add-to-list 'meow-mode-state-list state))
  )

(use-package meow-tree-sitter
  :config (meow-tree-sitter-register-defaults))

;;; Editing aids

(use-package which-key
  :straight (:type built-in)
  :hook (after-init . which-key-mode)
  :init
  (when after-init-time
    (which-key-mode 1))
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

(use-package elec-pair
  :straight (:type built-in)
  :config
  (add-hook 'prog-mode-hook 'electric-pair-local-mode)
  (add-hook 'conf-mode-hook 'electric-pair-local-mode)
  (setq electric-pair-inhibit-predicate (lambda (char) (minibufferp))))

(use-package eldoc
  :straight (:type built-in)
  :custom
  (eldoc-documentation-strategy #'eldoc-documentation-compose)
  :config
  (setq eldoc-echo-area-display-truncation-message t
        eldoc-echo-area-prefer-doc-buffer t
        eldoc-help-at-pt t
        eldoc-echo-area-use-multiline-p nil))

;;; Chinese input and typography

(use-package rime
  :straight (rime :type git
                  :host github
                  :repo "DogLooksGood/emacs-rime"
                  :files ("*.el" "Makefile" "lib.c"))
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'posframe)
  :config
  ;; meow-mode hook
  (setq rime-disable-predicates
        '(meow-normal-mode-p
          meow-motion-mode-p
          meow-keypad-mode-p))
  (setq rime-posframe-properties
        (list :font "LXGW WenKai Screen-14"
              ;;  :internal-border-width 10
              ))
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime")
  :bind
  (:map rime-mode-map
        ("C-`" . 'rime-send-keybinding))
  )

(use-package pangu-spacing
  :config
  (global-pangu-spacing-mode 1)
  (let ((enable-pangu-spacing
         #'(lambda ()
             (set (make-local-variable 'pangu-spacing-real-insert-separtor) t))))
    (add-hook 'org-mode-hook enable-pangu-spacing)
    (add-hook 'markdown-ts-mode-hook enable-pangu-spacing)))

;;; Translation

(use-package gt
  :bind (("C-c k" . gt-translate))
  :config
  (setq gt-langs '(en zh))
  (setq gt-default-translator
        (gt-translator
         :taker   (gt-taker :text 'word :pick 'paragraph)       
         :engines (gt-google-engine)
         :render  (gt-buffer-render)))
  )

(provide 'init-editing)

;;; init-editing.el ends here
