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
          ("N" . dashboard-next-section)
          ("p" . dashboard-previous-line)
          ("F" . dashboard-previous-section)
          ("o" . dashboard-jump-to-projects)))
  :init
  (setq
   dashboard-center-content t
   dashboard-set-file-icons t
   dashboard-set-heading-icons t
   ;; dashboard-set-footer t
   dashboard-set-navigator t
   dashboard-page-separator "\n"
   dashboard-set-init-info t
   ;; dashboard-startup-banner "~/.emacs.d/logo_umu.svg"
   ;; dashboard-startup-banner 'logo
   dashboard-projects-backend 'projectile
   dashboard-items '((recents  . 10)
                     (projects  . 5)))
  (setq dashboard-startupify-list '(dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline
                                    dashboard-insert-footer))
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

(use-package tab-bar
  :straight (:type built-in)
  :hook (after-init . tab-bar-mode)
  :custom
  (tab-bar-history-buttons-show nil)
  :bind (("C-c n n" . tab-new)
         ("C-c n x" . tab-close))
  :config
  (setq tab-bar-separator ""
        tab-bar-tab-name-truncated-max 20
        tab-bar-auto-width nil
        tab-bar-close-button-show nil
        tab-bar-tab-hints t)
  (setq tab-bar-tab-name-format-function
        (lambda (tab i)
          (let ((face (funcall tab-bar-tab-face-function tab)))
            (concat
             (propertize " " 'face face)
             (propertize (number-to-string i) 'face `(:inherit ,face :weight ultra-bold :underline t))
             (propertize (concat " " (alist-get 'name tab) " ") 'face face)))))
  (defun lan/show-tab-bar ()
    (interactive)
    (setq tab-bar-format '(tab-bar-format-menu-bar
                           ;;meow-indicator
                           tab-bar-format-tabs tab-bar-separator))
    (tab-bar--update-tab-bar-lines))
  (lan/show-tab-bar)
  )

;; (use-package parrot
;;   :config
;;   (parrot-mode)
;;   (setq parrot-num-rotations nil))


(provide 'init-ui)
