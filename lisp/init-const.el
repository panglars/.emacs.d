;; -*- lexical-binding: t; -*-
(defconst my-cache-dir (concat user-emacs-directory "cache/")
  "Emacs cache directory.")

(unless (file-exists-p my-cache-dir)
  (make-directory my-cache-dir))

(defcustom my-org-directory (expand-file-name "~/Documents/Org")
  "Org file"
  :type '(string))

(defcustom my-org-roam-directory (expand-file-name "~/Documents/Org/Notes/")
  "Org roam file"
  :type '(string))

(defcustom my-emacs-load-icons t
  "user must do this manually with M-x nerd-icons-install-fonts."
  :type 'boolean)

(defcustom my-light-theme 'modus-operandi-tinted
  "The theme to use when in light mode."
  :type 'symbol)

(defcustom my-dark-theme 'modus-vivendi-tinted
  "The theme to use when in dark mode."
  :type 'symbol)


(provide 'init-const)
