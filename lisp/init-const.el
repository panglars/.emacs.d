(defconst my-cache-dir (concat user-emacs-directory "cache/")
  "Emacs cache directory.")

(unless (file-exists-p my-cache-dir)
  (make-directory my-cache-dir))

(defcustom my-org-directory (expand-file-name "~/Dropbox/Org")
  "Org file"
  :type '(string))

(defcustom my-org-roam-directory (expand-file-name "~/Dropbox/Notes/")
  "Org roam file"
  :type '(string))

(defcustom my-emacs-load-icons t
  "user must do this manually with M-x nerd-icons-install-fonts."
  :type 'boolean)

(provide 'init-const)
