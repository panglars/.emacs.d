;;; init.el --- Load the full configuration -*- lexical-binding: t -*-


(when (version< emacs-version "29.1")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

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
  :hook (after-init . gcmh-mode)
  :config
  (setq gcmh-high-cons-threshold (* 128 1024 1024)))

(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

;; Specify default Font
(cond
 ((string-equal system-name "SF24")
  (cl-loop for font in '("Iosevka Nerd Font Mono" "Source Code Pro" "Courier New")
           when (find-font (font-spec :name font))
           return (set-face-attribute 'default nil
                                      :font font
                                      :height 120)))
 ((string-equal system-name "sf1000")
  (cl-loop for font in '("CodeNewRoman Nerd Font" "Source Code Pro" "Courier New")
           when (find-font (font-spec :name font))
           return (set-face-attribute 'default nil
                                      :font font
                                      :height 140))))

;; Specify font for all unicode characters
(cl-loop for font in '("CMU Typewriter Text" "Apple Color Emoji" "Symbola")
         when (font-installed-p font)
         return(set-fontset-font t 'unicode font nil 'prepend))
;; Specify font for Chinese characters
(cl-loop for font in '("LXGW WenKai Screen" "WenQuanYi Micro Hei" "Microsoft Yahei")
         when (font-installed-p font)
         return (set-fontset-font t '(#x4e00 . #x9fff) font))

;; Load core config
(require 'init-const)
(require 'init-base)
(require 'init-core)

;; Editor
(require 'init-meow)
(require 'init-format)
(require 'init-chinese)

;; UI
(require 'init-ui)
(require 'init-highlight)
(require 'init-window)
(require 'init-buffer)

;; Completion
(require 'init-completion)
(require 'init-consult)

;; Lang
(require 'init-org)
(require 'init-prog)
(require 'init-treesitter)
(require 'init-python)
(require 'init-web)
(require 'init-fontend)
(require 'init-cxx)
(require 'init-golang)
(require 'init-rust)

;; IDE
(require 'init-git)
(require 'init-shell)
(require 'init-project)
(require 'init-flycheck)
(require 'init-lsp)
(require 'init-filemanager)

;; Misc
(require 'init-copilot)
(require 'init-reader)
(require 'init-intergration)
(require 'init-count)
;;

;;; init.el ends here
