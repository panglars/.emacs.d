;;  -*- lexical-binding: t; -*-

(use-package agent-shell
  :config
  (defun my/agent-shell-dot-subdir (subdir)
    (let* ((cwd (string-remove-suffix "/" (agent-shell-cwd)))
           (sanitized (replace-regexp-in-string "/" "-" (string-remove-prefix "/" cwd))))
      (expand-file-name subdir (locate-user-emacs-file (concat "agent-shell/" sanitized)))))

  (setopt agent-shell-dot-subdir-function #'my/agent-shell-dot-subdir)
  (setopt agent-shell-write-inhibit-minor-modes '(aggressive-indent-mode))
  )


(provide 'init-ai)
