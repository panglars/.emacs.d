;;; init-mini.el --- Meow for quick terminal editing -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Load Meow and its basic editing keys

(let ((config-directory (file-name-directory (file-truename load-file-name))))
  (add-to-list 'load-path (expand-file-name "straight/build/meow" config-directory))
  (require 'lan-meow (expand-file-name "site-lisp/lan-meow.el" config-directory)))

(lan/meow-setup)
(meow-global-mode 1)

;;; init-mini.el ends here
