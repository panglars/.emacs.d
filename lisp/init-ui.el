(use-package dashboard
  :hook (dashboard-mode . (lambda ()
                            ;; No title
                            (setq-local frame-title-format nil)
                            ;; Enable `page-break-lines-mode'
                            (when (fboundp 'page-break-lines-mode)
                              (page-break-lines-mode 1))))
  :bind (("<f2>" . dashboard-open)
         :map dashboard-mode-map
         )

  :init
  (setq
   dashboard-center-content t
   dashboard-set-file-icons t
   dashboard-set-heading-icons t
   dashboard-set-footer t
   dashboard-set-navigator t
   dashboard-page-separator "\n\f\n"
   dashboard-set-init-info t
   dashboard-startup-banner "~/.emacs.d/logo.svg"
   dashboard-projects-backend 'projectile
   dashboard-items '((recents  . 15)
                     (bookmarks . 3)
                     (projects . 8)
                     (agenda . 5)))
  (dashboard-setup-startup-hook)
  )

;; TODO add load-session

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  (setq doom-modeline-height 1
        doom-modeline-window-width-limit 100
        doom-modeline-minor-modes nil))

(use-package hide-mode-line
  :hook (((eshell-mode shell-mode
                       term-mode vterm-mode
                       lsp-ui-imenu-mode
                       pdf-annot-list-mode) . hide-mode-line-mode)))

(use-package page-break-lines
  :hook (after-init . global-page-break-lines-mode))

(use-package parrot
  :config
  (parrot-mode)
  (setq parrot-num-rotations nil))


(provide 'init-ui)
