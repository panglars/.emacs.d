;;; init.el --- Load the full configuration -*- lexical-binding: t -*-

;;; Code:

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq load-prefer-newer t)
(setq native-compile-prune-cache t)

;;;; Load core config

(require 'init-base)
(require 'init-core)

(require 'init-meow)
(require 'init-chinese)

(require 'init-ui) ;; window, buffer and frame

;; Completion
(require 'init-completion)
(require 'init-consult)

;; IDE
(require 'init-project)
(require 'init-linting)
(require 'init-filemanager)

;; Lang
(require 'init-org)
(require 'init-cxx)
(require 'init-prog)
(require 'init-lsp)

;; Misc
(require 'init-reader)
(require 'init-intergration) ;; shell, mail, llm

(server-start)

;;; init.el ends here
