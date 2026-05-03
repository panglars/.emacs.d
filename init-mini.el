;;; init-mini.el --- Emacs minimal configurations.	-*- lexical-binding: t no-byte-compile: t -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Load core config
(require 'init-base)
(require 'init-core)

(require 'init-meow)

(require 'init-completion)
(require 'init-consult)
