;;; init-fontend.el ---

(use-package tsx-ts-helper-mode
  :straight (tsx-ts-helper-mode
             :type git
             :host codeberg
             :repo "ckruse/tsx-ts-helper-mode")
  :commands (tsx-ts-helper-mode)
  :custom (tsx-ts-helper-mode-keymap-prefix (kbd "C-c C-t"))
  :hook (tsx-ts-mode . tsx-ts-helper-mode))


(use-package jsdoc
  :straight (:host github :repo "isamert/jsdoc.el"))


(provide 'init-fontend)


