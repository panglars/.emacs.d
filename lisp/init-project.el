;; -*- lexical-binding: t; -*-

(use-package magit
  :init
  ;; Suppress the message we get about "Turning on magit-auto-revert-mode" when loading Magit.
  (setq magit-no-message '("Turning on magit-auto-revert-mode...")
        magit-diff-refine-hunk t)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (setq fill-column 72
        magit-auto-revert-mode t
        git-commit-summary-max-length 50
        magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")
        git-commit-style-convention-checks '(overlong-summary-line non-empty-second-line)))

(use-package diff-hl
  :config
  (setq diff-hl-disable-on-remote t)
  (global-diff-hl-mode))

(use-package smerge-mode
  :straight (:type built-in))

;; Git config file modes
(use-package git-modes)

(use-package blamer
  :straight (:host github :repo "artawower/blamer.el")
  :bind (("C-c l g" . blamer-show-posframe-commit-info))
  :custom
  (blamer-idle-time 0.1)
  (blamer-min-offset 40)
  (blamer-author-formatter "  ✎ %s ")
  )

(use-package projectile
  :bind (:map projectile-mode-map
              ("C-c C-p" . projectile-command-map))
  :hook (after-init . projectile-mode)
  :config
  (setq projectile-mode-line-prefix ""
        projectile-sort-order 'recentf
        projectile-use-git-grep t)
  )

(use-package breadcrumb
  :defer t)

(provide 'init-project)
