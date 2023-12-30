(use-package page-break-lines
  :config
  (set-fontset-font "fontset-default"
                    (cons page-break-lines-char page-break-lines-char)
                    "CMU Typewriter Text")
  )

(use-package dashboard
  :diminish (dashboard-mode page-break-lines-mode)
  :hook (dashboard-mode . (lambda ()
                            ;; No title
                            (setq-local frame-title-format nil)
                            (when (fboundp 'page-break-lines-mode)(page-break-lines-mode 1))
                            ))
  :bind (("<f2>" . dashboard-open)
         :map dashboard-mode-map
         (("n" . dashboard-next-line)
          ("p" . dashboard-previous-line)
          ("N" . dashboard-next-section)
          ("F" . dashboard-previous-section)
          ("o" . dashboard-jump-to-projects)))
  :init
  (setq
   dashboard-center-content t
   dashboard-set-file-icons t
   dashboard-set-heading-icons t
   dashboard-set-footer t
   dashboard-set-navigator t
   dashboard-page-separator "\n\f\n"
   dashboard-set-init-info t
   ;; dashboard-startup-banner "~/.emacs.d/logo.svg"
   dashboard-startup-banner 'logo
   dashboard-projects-backend 'projectile
   dashboard-items '((recents  . 10)
                     (bookmarks . 5)
                     (projects . 8)))
  (dashboard-setup-startup-hook))

;; TODO add load-session

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-height 25
        doom-modeline-window-width-limit 100
        doom-modeline-minor-modes nil))

(use-package hide-mode-line
  :hook (((eshell-mode shell-mode
                       term-mode
                       lsp-ui-imenu-mode
                       pdf-annot-list-mode) . hide-mode-line-mode)))


;; (use-package parrot
;;   :config
;;   (parrot-mode)
;;   (setq parrot-num-rotations nil))


(provide 'init-ui)
