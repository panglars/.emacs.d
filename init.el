;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

(let ((minver "28.2"))
  (when (version< emacs-version minver)
    (error "Your Emacs is old -- this config requires v%s or higher" minver)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; (require 'init-benchmarking) ;; Measure startup time

;; Adjust garbage collection thresholds during startup, and thereafter
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))


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
(require 'init-lsp)

;; VCS
(require 'init-git)

;; Lang
(require 'init-org)
(require 'init-treesit)
(require 'init-python)
(require 'init-web)
(require 'init-javascript)
(require 'init-cxx)
(require 'init-golang)
(require 'init-prog)
(require 'init-rust)

;; IDE
(require 'init-project)
(require 'init-flycheck)
(require 'init-filemanager)

;; Misc
(require 'init-shell)
(require 'init-copilot)
(require 'init-telega)
;;
