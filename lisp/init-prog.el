(use-package vlf)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package typst-ts-mode
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode")
  :custom
  (typst-ts-mode-watch-options "--open"))

(use-package lua-mode)

;; CSV highlight
(use-package rainbow-csv
  :straight (:host github :repo "emacs-vs/rainbow-csv"))

(use-package devdocs
  :bind
  ("C-c S" . devdocs-lookup))

(use-package fingertip
  :straight (:host github :repo "manateelazycat/fingertip"))

(use-package quickrun
  :custom
  (quickrun-timeout-seconds 60)
  :bind
  (("<f5>" . quickrun)
   ("M-<f5>" . quickrun-shell)))

(use-package yasnippet
  :defer t
  :custom
  (yas-use-menu nil)
  :config
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  (add-hook 'yas-keymap-disable-hook
            (lambda ()
              (and (frame-live-p corfu--frame)
                   (frame-visible-p corfu--frame))))
  
  (use-package yasnippet-snippets)
  (use-package consult-yasnippet
    :bind
    ("C-c y" . consult-yasnippet))

  (setq yas-inhibit-overlay-modification-protection t)
  (advice-add 'yas--on-protection-overlay-modification :override #'ignore)
  )

;; (use-package yasnippet-capf
;;   :load-path "site-lisp"
;;   :after cape
;;   :config
;;   (add-to-list 'completion-at-point-functions #'yasnippet-capf))


(provide 'init-prog)

