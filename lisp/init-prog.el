(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; (use-package treesit
;;   :straight (:type built-in)
;;   :mode (("\\.js\\'" . js-ts-mode)
;;          ("\\.ts\\'" . typescript-ts-mode)
;;          ("\\.tsx\\'" . tsx-ts-mode)))
;; (setq major-mode-remap-alist
;;       '((yaml-mode . yaml-ts-mode)
;;         (bash-mode . bash-ts-mode)
;;         (json-mode . json-ts-mode)
;;         (css-mode . css-ts-mode)))

(use-package typst-ts-mode
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode")
  :custom
  (typst-ts-mode-watch-options "--open"))

(use-package fingertip
  :straight (:host github :repo "manateelazycat/fingertip"))

;; (use-package yasnippet
;;   :defer t
;;   :hook ((prog-mode org-mode markdown-mode) . yas-minor-mode)
;;   :custom
;;   (yas-use-menu nil)
;;   :config
;;   (setq yas-inhibit-overlay-modification-protection t)
;;   (advice-add 'yas--on-protection-overlay-modification :override #'ignore)
;;   (use-package yasnippet-snippets)
;;   )
;; 
;; (use-package consult-yasnippet)

;; Templ.el
(use-package tempel
  :init

  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

(use-package tempel-collection)


(use-package quickrun
  :custom
  (quickrun-timeout-seconds 60)
  :bind
  (("<f5>" . quickrun)
   ("M-<f5>" . quickrun-shell)))
(provide 'init-prog)

