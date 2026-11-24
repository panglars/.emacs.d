;;; init-project.el --- Projects, version control and workspaces -*- lexical-binding: t; -*-

;;; Version control

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

;;; Project navigation

(use-package project
  :straight (:type built-in)
  :bind (:map project-prefix-map
              ("m" . magit-status)
              ("t" . eat-project))
  :config
  (setq project-vc-extra-root-markers '(".project")
        project-switch-commands '((project-find-file "File")
                                  (project-find-regexp "Regexp")
                                  (project-switch-to-buffer "Buffer")
                                  (project-dired "Dired")
                                  (eat-project "Eat")
                                  (magit-status "Magit"))))

;;; File manager

(use-package dired
  :straight (:type built-in)
  :bind (("C-c d" . dired-jump)
         ("C-c D" . consult-fd)
         :map dired-mode-map
         ("b" . +dired-quick-access)
         ("f" . consult-fd)
         ("e" . dired-up-directory)
         ("i" . dired-find-file)
         ("S" . dired-sort-toggle-or-edit)
         ("." . dired-omit-mode)
         ("<mouse-2>" . dired-mouse-find-file-other-window)
         ("<mouse-3>" . dired-mouse-find-file))
  :config
  (defvar +dired-quick-access-entries
    '(("h" "~/" "Home")
      ("d" "~/Downloads" "Downloads")
      ("D" "~/Documents" "Documents")
      ("P" "~/Pictures" "Pictures")
      ("c" "~/Codes" "Codes")
      ("p" "~/Codes/Project/" "Project")
      ("o" "~/Documents/Org/" "Org")
      ("n" "~/Documents/Notes/" "Notes")
      ("e" "/etc/" "etc")
      ("u" "/usr/" "usr")
      ("v" "/var/" "var")
      ("t" "~/.local/share/Trash/files" "TrashCan")
      ("E" "~/.emacs.d" ".emacs.d")
      ("f" "~/.config" ".config")
      ("l" "~/.local/share" ".local/share"))
    "Quick-access directories for `+dired-quick-access'.")

  (defun +dired-quick-access ()
    "Jump to a predefined directory from `+dired-quick-access-entries'."
    (interactive)
    (let* ((candidates
            (mapcar (lambda (entry)
                      (pcase-let ((`(,key ,dir ,label) entry))
                        (cons (format "%-2s %-14s %s" key label dir) dir)))
                    +dired-quick-access-entries))
           (choice (completing-read "Quick access: " candidates nil t)))
      (dired (cdr (assoc choice candidates)))))

  (setq delete-by-moving-to-trash t
        dired-clean-confirm-killing-deleted-buffers nil
        dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group"
        dired-kill-when-opening-new-dired-buffer t
        dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'top
        dired-auto-revert-buffer t))

(use-package dired-x
  :straight (:type built-in)
  :after dired
  :hook (dired-mode . dired-omit-mode))

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

;;; Workspaces

(use-package tabspaces
  :straight (:type git :host codeberg :repo "mclear-tools/tabspaces")
  :hook (after-init . tabspaces-mode) 
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers nil)
  (tabspaces-initialize-project-with-todo nil)
  (tabspaces-todo-file-name "project-todo.org")
  (tabspaces-project-switch-opens-workspace t)
  (tabspaces-project-switch-commands #'project-dired)
  ;; sessions
  (tabspaces-session t)
  (tabspaces-session-auto-restore t)
  (tabspaces-session-project-session-store
   (expand-file-name ".cache/tabspaces-sessions/" user-emacs-directory))
  ;; additional options
  (tabspaces-fully-resolve-paths t)  ; Resolve relative project paths to absolute
  (tabspaces-exclude-buffers '("*Messages*" "*Compile-Log*"))  ; Additional buffers to exclude
  :init
  ;; Only auto-restore per-project sessions when switching projects,
  ;; instead of restoring all global/non-project tabs on Emacs startup.
  (advice-add 'tabspaces--restore-session-on-startup :override #'ignore)
  (advice-add 'tabspaces-save-non-project-tabs :override #'ignore)
  :config

  (defun +tabspaces--cycle-buffer (direction)
    "Cycle buffers belonging to the current tabspace in DIRECTION (`next' or `prev')."
    (let* ((buffers (seq-filter (lambda (buf)
                                  (and (buffer-live-p buf)
                                       (not (string-prefix-p " " (buffer-name buf)))))
                                (tabspaces-local-buffer-list)))
           (pos (seq-position buffers (current-buffer))))
      (when (> (length buffers) 1)
        (let* ((len (length buffers))
               (next-idx (if pos
                             (mod (+ pos (if (eq direction 'next) 1 -1)) len)
                           0)))
          (switch-to-buffer (nth next-idx buffers))))))

  (defun +tabspaces-next-buffer ()
    "Switch to the next buffer in the current tabspace."
    (interactive)
    (+tabspaces--cycle-buffer 'next))

  (defun +tabspaces-previous-buffer ()
    "Switch to the previous buffer in the current tabspace."
    (interactive)
    (+tabspaces--cycle-buffer 'prev)))

;;; Integration with other modules

(with-eval-after-load 'dashboard
  (setq dashboard-projects-backend 'project-el))

(with-eval-after-load 'init-completion
  (with-eval-after-load 'dired
    (keymap-set dired-mode-map "s" #'consult-line)))

(with-eval-after-load 'init-editing
  (meow-leader-define-key '("G" . magit)
                          '("p" . "C-x p")
                          '("," . +tabspaces-previous-buffer)
                          '("." . +tabspaces-next-buffer)))

(provide 'init-project)

;;; init-project.el ends here
