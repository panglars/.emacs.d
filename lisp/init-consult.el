(use-package consult
  :bind(;; C-c bindings in `mode-specific-map'
        ("C-c M-x" . consult-mode-command)
        ("C-c b"   . consult-buffer)
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
  )

;; [consult-dir] Insert path quickly in minibuffer
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file))
  )

(provide 'init-consult)
