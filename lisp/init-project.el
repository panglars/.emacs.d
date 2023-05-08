(use-package projectile
  :bind (:map projectile-mode-map
              ("C-c C-p" . projectile-command-map))
  :hook (after-init . projectile-mode)
  :config
  (setq projectile-mode-line-prefix ""
        projectile-sort-order 'recentf
        projectile-use-git-grep t)
  )

(provide 'init-project)
