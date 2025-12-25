;;  -*- lexical-binding: t; -*-

(use-package eee
  :straight '(:type git :host github :repo "eval-exec/eee.el"
                    :files (:defaults "*.el" "*.sh"))
  :config
  (setq ee-terminal-command "ghostty"))


(use-package dirvish
  :straight (:type git :host github :repo "alexluigit/dirvish")
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
  
  :bind ; Bind `dirvish|dirvish-side|dirvish-dwim' as you see fit
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
   ("s"   . consult-line)
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

(provide 'init-filemanager)
