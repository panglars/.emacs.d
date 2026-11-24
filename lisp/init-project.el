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

(use-package dirvish
  :straight (:type git :host github :repo "latiagertrutis/dirvish")
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(
     ("h" "~/" "Home")
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
     ("e" "~/.emacs.d" ".emacs.d")
     ("f" "~/.config" ".config")
     ("l" "~/.local/share" ".local/share")
     ))

  :hook
  (dirvish-mode . dired-omit-mode)
  
  :config
  ;; (dirvish-peek-mode) ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'
  
  (setq dirvish-default-layout '(0 0.4 0.6))
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(nerd-icons collapse file-time file-size))
  (setq delete-by-moving-to-trash t)
  (setq dirvish-subtree-state-style 'nerd)
  (setq dired-clean-confirm-killing-deleted-buffers nil)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  (setq dirvish-path-separators (list
                                 (format " %s " (nerd-icons-codicon "nf-cod-home"))
                                 (format " %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                 (format " %s " (nerd-icons-faicon "nf-fa-angle_right"))))
  (setq dirvish-hide-details '(dirvish-side))
  
  ;; mouse support 
  (define-key dirvish-mode-map (kbd "<mouse-1>") 'dirvish-subtree-toggle-or-open)
  (define-key dirvish-mode-map (kbd "<mouse-2>") 'dired-mouse-find-file-other-window)
  (define-key dirvish-mode-map (kbd "<mouse-3>") 'dired-mouse-find-file)
  
  :bind 
  (("C-c d" . dirvish-dwim)
   ("C-c D" . dirvish-fd)
   :map dirvish-mode-map ; Dirvish inherits `dired-mode-map'
   ("b"   . dirvish-quick-access)
   ("f"   . dirvish-fd)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("e"   . dired-up-directory)
   ("i"   . dired-find-file)
   ("^"   . dirvish-history-last)
   ("h"   . dirvish-history-jump) ; remapped `describe-mode'
   ("S"   . dirvish-quicksort)    ; remapped `dired-sort-toggle-or-edit'
   ("v"   . dirvish-vc-menu)      ; remapped `dired-view-file'
   ("T"   . dirvish-side)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-l" . dirvish-ls-switches-menu)
   ("M-m" . dirvish-mark-menu)
   ("M-t" . dirvish-layout-toggle)
   ("M-s" . dirvish-setup-menu)
   ("M-e" . dirvish-emerge-menu)
   ("M-j" . dirvish-fd-jump)))

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
  (with-eval-after-load 'dirvish
    (keymap-set dirvish-mode-map "s" #'consult-line)))

(with-eval-after-load 'init-editing
  (meow-leader-define-key '("G" . magit)
                          '("p" . "C-x p")
                          '("," . +tabspaces-previous-buffer)
                          '("." . +tabspaces-next-buffer))
  (meow-normal-define-key '("T" . dirvish-side)))

(provide 'init-project)

;;; init-project.el ends here
