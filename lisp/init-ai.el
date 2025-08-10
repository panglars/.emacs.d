;;  -*- lexical-binding: t; -*-
(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :bind ("C-c C-v" . claude-code-ide-menu) 
  :config
  (claude-code-ide-emacs-tools-setup)) 

(provide 'init-ai)
