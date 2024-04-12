
;; Transparent title bar
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))

(setq use-short-answers t)

;; Inhibit switching out from `y-or-n-p' and `read-char-choice'
(setq y-or-n-p-use-read-key t
      read-char-choice-use-read-key t)

;; Cutting and pasting use primary/clipboard
(setq select-enable-clipboard t)
(setq select-active-regions 'only)

;; No backup files,No lock files 
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; Make native compilation silent
(setq native-compile-prune-cache t)

;; Always load the newest file
(setq load-prefer-newer t)

;; Move to trash when delete file
(setq-default  delete-by-moving-to-trash t)

(global-visual-line-mode 1)

(setq column-number-mode t)

(setq mouse-yank-at-point t)

;; No gc for font caches
(setq inhibit-compacting-font-caches t)

;; No annoying bell
(setq ring-bell-function 'ignore)

;; No eyes distraction
(setq blink-cursor-mode nil)

;; Suppress GUI features and more
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-x-resources t
      inhibit-default-init t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-buffer-menu t)

;; Optimize for very long lines
(setq bidi-paragraph-direction 'left-to-right
      bidi-inhibit-bpa t)

;; Disable cursor in non-selected windows.
(setq-default cursor-in-non-selected-windows nil)

;; Improve display
(setq display-raw-bytes-as-hex t)

;; Scroll
(setq scroll-step 1
      scroll-margin 0
      hscroll-step 1
      hscroll-margin 0
      scroll-conservatively 100000
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      auto-window-vscroll nil
      scroll-preserve-screen-position t)

(when (display-graphic-p)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil))

;; Remove hscroll-margin in shells, otherwise it causes jumpiness
(add-hook 'eshell-mode-hook (lambda() (setq hscroll-margin 0)))
(add-hook 'term-mode-hook (lambda() (setq hscroll-margin 0)))

;; Indentation
(setq-default tab-width 4
              fill-column 80
              tab-always-indent t
              indent-tabs-mode nil)

;; Word wrapping
(setq-default word-wrap nil
              truncate-lines t
              truncate-partial-width-windows nil)


(provide 'init-base)
