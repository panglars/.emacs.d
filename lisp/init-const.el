(defconst my-cache-dir (concat user-emacs-directory "cache/")
  "Emacs cache directory.")
(unless (file-exists-p my-cache-dir)
  (make-directory my-cache-dir))
(defconst my-lsp-backend 'lsp-mode
  "Which language server to use, eglot, lsp-mode or lsp-bridge")

(defcustom my-org-directory (expand-file-name "~/Org/")
  "Org file"
  :type '(string))

(provide 'init-const)
