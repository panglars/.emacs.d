(use-package rust-mode
  :hook ((rust-mode . my/rust-lsp))
  :config
  (setq rust-format-on-save t)
  (defun my/rust-lsp ()
    (setq-local lsp-completion-enable nil
                compile-command "cargo build")
    ))

(cl-defmethod lsp-clients-extract-signature-on-hover (contents (_server-id (eql rust-analyzer)))
  (-let* (((&hash "value") contents)
          (groups (--partition-by (s-blank? it) (s-lines (s-trim value))))
          (sig_group (if (s-equals? "```rust" (car (-third-item groups)))
                         (-third-item groups)
                       (car groups)))
          (sig (--> sig_group
                    (--drop-while (s-equals? "```rust" it) it)
                    (--take-while (not (s-equals? "```" it)) it)
                    (s-join "" it))))
    (lsp--render-element (concat "```rust\n" sig "\n```"))))


(provide 'init-rust)
