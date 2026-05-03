;; -*- lexical-binding: t; -*-

;; Adjust garbage collection threshold for early startup (see use of gcmh below)
(setq gc-cons-threshold (* 128 1024 1024))

;; Process performance tuning
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;; Use straight as package manager
(setq straight--process-log nil
      straight-cache-autoloads t
      straight-repository-branch "develop"
      straight-enable-package-integration nil
      straight-vc-git-default-clone-depth 1
      straight-use-package-by-default t
      use-package-always-ensure nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(setq use-package-enable-imenu-support t
      use-package-verbose (not (bound-and-true-p byte-compile-current-file))
      use-package-expand-minimally t
      use-package-compute-statistics nil)
(setq byte-compile-warnings '(cl-functions))
(straight-use-package 'use-package)

;; Load custom file
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(use-package gcmh
  :disabled
  :hook (after-init . gcmh-mode)
  :config
  (setq gcmh-high-cons-threshold (* 128 1024 1024)))

;;;; Font
(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(cond
 ((string-equal system-name "SF25")
  (cl-loop for font in '("CodeNewRoman Nerd Font 11" "Source Code Pro 11")
           when (find-font (font-spec :name font))
           return (set-face-attribute 'default nil
                                      :font font)))
 ((string-equal system-name "sf1000")
  (cl-loop for font in '("CodeNewRoman Nerd Font 13" "Source Code Pro 12")
           when (find-font (font-spec :name font))
           return (set-face-attribute 'default nil
                                      :font font))))

;; Specify font for all unicode characters
(cl-loop for font in '("CMU Typewriter Text" "Apple Color Emoji" "Symbola")
         when (font-installed-p font)
         return(set-fontset-font t 'unicode font nil 'prepend))
;; Specify font for Chinese characters
(cl-loop for font in '("LXGW WenKai Screen" "WenQuanYi Micro Hei" "Microsoft Yahei")
         when (font-installed-p font)
         return (set-fontset-font t '(#x4e00 . #x9fff) font))

(defcustom ORG-PATH (expand-file-name "~/Documents/Org")
  "Org files directory"
  :type '(string))

(setq desktop-path '("~/.emacs.d/"))

;; Transparent title bar
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))

(setq use-short-answers t)

;; (setq ad-redefinition-action 'accept)

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

;; Re-read files on disk when there’s a change
(setq auto-revert-interval 1)
(setq auto-revert-check-vc-info t)
;; (setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode)

(provide 'init-base)
