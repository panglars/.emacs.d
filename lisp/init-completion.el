(use-package corfu
  :straight (corfu :includes (corfu-indexed corfu-quick) :files (:defaults "extensions/corfu-*.el"))
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-bar-width 0.5)
  (corfu-quit-at-boundary t)
  (corfu-quit-no-match t)
  (corfu-max-width 60)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-preview-current nil)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-j" . corfu-reset)
              ("M-h" . corfu-info-documentation)
              ("C-g" . corfu-quit)
              ("M-n" . corfu-insert-separator))
  :init
  (global-corfu-mode 1)
  :config
  (setq corfu-excluded-modes '(shell-mode
                               eshell-mode
                               comint-mode
                               erc-mode
                               gud-mode
                               rcirc-mode
                               text-mode
                               minibuffer-inactive-mode))
  ;; extensions
  (use-package nerd-icons-corfu
    :config
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
  ;; Commands to select using Avy-style quick keys.
  (use-package corfu-quick
    :straight nil
    :after corfu
    :bind (:map corfu-map
                ("C-q" . corfu-quick-insert)))
  (use-package corfu-history
    :straight nil
    :after corfu
    :hook (corfu-mode . corfu-history-mode))
  (use-package corfu-popupinfo
    :straight nil
    :after corfu
    :bind (:map corfu-map(("M-p" . corfu-popupinfo-scroll-down)
                          ("M-n" . corfu-popupinfo-scroll-up)
                          ("M-d" . corfu-popupinfo-toggle)))
    :config
    (setq corfu-popupinfo-delay '(0.5 . 0.2)
          corfu-popupinfo-max-width 60)
    (corfu-popupinfo-mode 1))
  ;; A bunch of completion at point extensions
  (use-package cape
    :after corfu
    :config
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-keyword)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev))

  (defun my/set-mixed-capf ()
    (setq-local completion-category-defaults nil)
    (setq-local completion-at-point-functions (list
		                                       (cape-capf-buster
                                                (cape-super-capf
                                                 (pcase my-lsp-backend
                                                   ('lsp-bridge #'lsp-bridge-capf)
                                                   ('eglot #'eglot-completion-at-point)
                                                   ('lsp-mode #'lsp-completion-at-point)
                                                   (_ #'lsp-completion-at-point))
                                                 #'cape-file
                                                 #'cape-keyword
                                                 #'cape-dabbrev)
                                                'equal))))

  ;; (add-hook 'lsp-bridge-mode-hook #'my/set-mixed-capf)
  (add-hook 'lsp-completion-mode-hook #'my/set-mixed-capf))

(use-package orderless
  :init
  (setq completion-styles '(orderless flex)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))


(use-package vertico
  :straight (vertico :includes (vertico-repeat)
                     :files (:defaults "extensions/vertico-*.el"))
  :hook (after-init . vertico-mode)
  :config
  (setq vertico-resize nil
        vertico-count 15
        vertico-cycle t)

  ;; Repeat last session
  (use-package vertico-repeat
    :after vertico
    :ensure nil
    :bind ("C-c C-r" . vertico-repeat)
    :config
    (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)))


(use-package savehist
  :init
  (savehist-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Either bind `marginalia-cycle' globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  ;; The :init configuration is always executed (Not lazy!)
  :init
  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

(use-package all-the-icons-completion
  :init
  (all-the-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup))

(provide 'init-completion)
