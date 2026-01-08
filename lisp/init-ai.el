;;  -*- lexical-binding: t; -*-

(use-package agent-shell
  :config
  (setq agent-shell-google-authentication
        (agent-shell-google-make-authentication :login t))
  )


(provide 'init-ai)
