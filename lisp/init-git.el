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
  :after magit
  :config
  (magit-todos-mode 1))

;; Git modes
(use-package git-modes)

(use-package blamer
  :straight (:host github :repo "artawower/blamer.el")
  :bind (("C-c l g" . blamer-show-posframe-commit-info))
  :custom
  (blamer-idle-time 0.1)
  (blamer-min-offset 40)
  (blamer-author-formatter "  ✎ %s ")
  )

(provide 'init-git)
