(use-package copilot
  :defer t
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("C-j" . copilot-accept-completion)
              ("M-j" . copilot-clear-overlay)
              ("C-c j n" . copilot-next-completion)
              ("C-c j p" . copilot-previous-completion))
  :init
  (setq copilot--indent-warning-printed-p t)
  )


(provide 'init-copilot)
