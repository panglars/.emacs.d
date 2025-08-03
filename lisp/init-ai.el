;;  -*- lexical-binding: t; -*-

(use-package claude-code
  :straight (:type git :host github :repo "stevemolitor/claude-code.el" :branch "main" :depth 1
                   :files ("*.el" (:exclude "images/*")))
  ;; :bind-keymap
  ;; ("C-c v" . claude-code-command-map) 
  :config
  (claude-code-mode))

(provide 'init-ai)
