;; -*- lexical-binding: t; -*-

(use-package eat
  :straight (:type git
                   :host codeberg
                   :repo "akib/emacs-eat"
                   :files ("*.el" ("term" "term/*.el") "*.texi"
                           "*.ti" ("terminfo/e" "terminfo/e/*")
                           ("terminfo/65" "terminfo/65/*")
                           ("integration" "integration/*")
                           (:exclude ".dir-locals.el" "*-tests.el")))
  :config
  (defun meomacs-eat-meow-setup ()
    (add-hook 'meow-normal-mode-hook 'eat-emacs-mode nil t)
    (add-hook 'meow-insert-mode-hook 'eat-char-mode nil t))

  (keymap-set eat-char-mode-map "C-S-v" 'eat-yank)
  (advice-add 'eat-semi-char-mode :after 'eat-emacs-mode)
  (add-hook 'eat-mode-hook 'meomacs-eat-meow-setup)
  )

(provide 'init-shell)
