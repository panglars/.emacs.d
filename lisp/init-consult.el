(use-package consult
  :bind(;; C-c bindings in `mode-specific-map'
        ("C-c M-x" . consult-mode-command)
        ("C-c b" . consult-buffer)
        ("C-c r" . consult-ripgrep)
        ("C-c f" . consult-flycheck)
        ("C-c F" . consult-fd)
        ("C-c i" . consult-imenu)
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
  :config
  (use-package consult-flycheck)
  )

;; [consult-dir] Insert path quickly in minibuffer
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package consult-org-roam
  :after (org-roam)
  :custom
  (consult-org-roam-grep-func #'consult-ripgrep)
  (consult-org-roam-buffer-after-buffers t)
  :bind
  ;; Define some convenient keybindings as an addition
  ("C-c n b" . consult-org-roam-backlinks)
  ("C-c n B" . consult-org-roam-backlinks-recursive)
  ("C-c n l" . consult-org-roam-forward-links)
  ("C-c n r" . consult-org-roam-search)
  :config
  (consult-org-roam-mode 1)
  (consult-customize
   consult-org-roam-forward-links
   :preview-key "M-."))


(provide 'init-consult)
