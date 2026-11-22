;;; init.el --- Load the full configuration -*- lexical-binding: t -*-

;;; Feature switches

(defvar lan/init-modules
  '((init-editing     . t)
    (init-ui          . t)
    (init-completion  . t)
    (init-project     . t)
    (init-org         . t)
    (init-prog        . t)
    (init-integration . t))
  "Configuration modules in startup order.  Set an entry to nil to skip it.")

;;; Load configuration

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq load-prefer-newer t)
(require 'init-base)

(dolist (module lan/init-modules)
  (when (cdr module)
    (require (car module))))

;; (server-start)

;;; init.el ends here
