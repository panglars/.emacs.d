;; Set up 'format-all' to format on save
(use-package format-all
  :hook (
         (prog-mode . (lambda ()
                        (unless (derived-mode-p 'text-mode)(format-all-mode) )))
         (format-all-mode  . format-all-ensure-formatter)))

(use-package aggressive-indent-mode
  :defer t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(provide 'init-format)
