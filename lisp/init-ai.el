;;  -*- lexical-binding: t; -*-

(use-package aidermacs
  :straight (:host github :repo "MatthewZMD/aidermacs" :files ("*.el"))
  :config
  (setq aidermacs-default-model "openrouter/anthropic/claude-3.7-sonnet")
  (global-set-key (kbd "C-c q") 'aidermacs-transient-menu)
                                        ; See the Configuration section below
  (setq aidermacs-backend 'vterm)
  (setq aidermacs-auto-commits nil)
  (setq aidermacs-use-architect-mode t))


(provide 'init-ai)
