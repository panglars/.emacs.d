;;  -*- lexical-binding: t; -*-

(use-package aidermacs
  :disabled
  :bind (("C-c q" . aidermacs-transient-menu))
  :config
  (setq aidermacs-default-model "openrouter/anthropic/claude-3.7-sonnet")
  ;; (setq aidermacs-backend 'vterm)
  ;; (setopt aidermacs-vterm-use-theme-colors nil)
  (setq aidermacs-comint-multiline-newline-key "S-<return>")
  (setq aidermacs-vterm-multiline-newline-key "S-<return>")
  (setq aidermacs-use-architect-mode t))


(provide 'init-ai)
