(use-package consult
  :bind(;; C-c bindings in `mode-specific-map'
        ("C-c M-x" . consult-mode-command)
        ("C-c b" . consult-buffer)
        ("C-c r" . consult-ripgrep)
        ("C-c F" . consult-fd)
        ("C-c R" . consult-bookmark)            ;; orig. bookmark-jump
        ("C-x b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
        ("C-x C-r" . consult-recent-file)
        ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
        ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
        ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
        ("M-#"   . consult-register-load)
        ("M-'"   . consult-register-store)        ;; orig. abbrev-prefix-mark (unrelated)
        ("C-M-#" . consult-register)
        ("M-y" . consult-yank-pop)                ;; orig. yank-pop
        )
  :init
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  )

;; [consult-dir] Insert path quickly in minibuffer
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file))
  )

(use-package consult-lsp
  :bind ("C-c l e" . consult-lsp-diagnostics))

;; (use-package consult-gh
;;   :straight (consult-gh :type git :host github :repo "armindarvish/consult-gh"
;;                         :after consult)
;;   :custom
;;   (consult-gh-repo-maxnum 30) ;;set max number of repos to 30
;;   (consult-gh-issues-maxnum 100) ;;set max number of issues to 100
;;   (consult-gh-show-preview t) ;;show previews
;;   (consult-gh-preview-key "M-o") ;;show previews on demand by hitting "M-o"
;;   (consult-gh-preview-buffer-mode 'org-mode) ;;show previews in org-mode
;;   (consult-gh-repo-action #'consult-gh--repo-browse-files-action) ;;open file tree of repo on selection
;;   (consult-gh-issue-action #'consult-gh--issue-view-action) ;;open issues in an emacs buffer
;;   (consult-gh-pr-action #'consult-gh--pr-view-action) ;;open pull requests in an emacs buffer
;;   (consult-gh-code-action #'consult-gh--code-view-action) ;;open files that contain code snippet in an emacs buffer
;;   (consult-gh-file-action #'consult-gh--files-view-action) ;;open files in an emacs buffer
;;   
;;   :config
;;   (add-to-list 'consult-gh-default-orgs-list "pang-lan")
;;   ;;use "gh org list" to get a list of all your organizations and adds them to default list
;;   (setq consult-gh-default-orgs-list (append consult-gh-default-orgs-list (remove "" (split-string (or (consult-gh--command-to-string "org" "list") "") "\n"))))
;; 
;;   (setq consult-gh-default-clone-directory "~/Codes/Repo/"))
;; 
(provide 'init-consult)
