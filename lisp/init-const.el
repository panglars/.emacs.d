(defconst my-cache-dir (concat user-emacs-directory "cache/")
  "Emacs cache directory.")

(unless (file-exists-p my-cache-dir)
  (make-directory my-cache-dir))

(defcustom my-org-directory (expand-file-name "~/Documents/Org/")
  "Org file"
  :type '(string))

(defcustom my-org-roam-directory (expand-file-name "~/Documents/Notes/")
  "Org roam file"
  :type '(string))

(provide 'init-const)
