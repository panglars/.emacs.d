;; -*- lexical-binding: t; -*-

(use-package magit
  :init
  ;; Suppress the message we get about "Turning on magit-auto-revert-mode" when loading Magit.
  (setq magit-no-message '("Turning on magit-auto-revert-mode...")
        magit-diff-refine-hunk t)
  :config
  (setq fill-column 72
        magit-auto-revert-mode t
        git-commit-summary-max-length 50
        magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")
        git-commit-style-convention-checks '(overlong-summary-line non-empty-second-line)))

(use-package smerge-mode
  :defer t
  :straight (:type built-in)
  :hook (find-file . (lambda ()
                       (save-excursion
                         (goto-char (point-min))
                         (when (re-search-forward "^<<<<<<< " nil t)
                           (smerge-mode 1))))))

(use-package magit-todos
  :disabled
  :after magit
  :config
  (magit-todos-mode 1))

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

(use-package activities
  :disabled
  :init
  (activities-mode)
  (activities-tabs-mode)
  ;; Prevent `edebug' default bindings from interfering.
  (setq edebug-inhibit-emacs-lisp-mode-bindings t)

  :bind
  (("C-x C-a C-n" . activities-new)
   ("C-x C-a C-d" . activities-define)
   ("C-x C-a C-a" . activities-resume)
   ("C-x C-a C-s" . activities-suspend)
   ("C-x C-a C-k" . activities-kill)
   ("C-x C-a RET" . activities-switch)
   ("C-x C-a b" . activities-switch-buffer)
   ("C-x C-a g" . activities-revert)
   ("C-x C-a l" . activities-list)))

(provide 'init-project)
