;;; -*- lexical-binding: t -*-

;; https://github.com/minad/corfu/discussions/457
(setq text-mode-ispell-word-completion nil)

(use-package corfu
  :straight (corfu :includes (corfu-indexed corfu-quick) :files (:defaults "extensions/corfu-*.el"))
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-bar-width 0.5)
  (corfu-quit-at-boundary t)
  (corfu-quit-no-match t)
  (corfu-max-width 100)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-preview-current nil)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-j" . corfu-reset)
              ("M-h" . corfu-info-documentation)
              ("C-g" . corfu-quit))
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
    :hook (corfu-mode . corfu-popupinfo-mode)
    :bind (:map corfu-map(("M-p" . corfu-popupinfo-scroll-down)
                          ("M-n" . corfu-popupinfo-scroll-up)
                          ("M-d" . corfu-popupinfo-toggle)))
    :config
    (setq corfu-popupinfo-delay '(0.5 . 0.5)
          corfu-popupinfo-min-height 10)))

;; A bunch of completion at point extensions
(use-package cape
  :after corfu
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package orderless
  :init
  (setq completion-styles '(orderless flex)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

;;vertical interactive completion 
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
    :bind ("C-c C-r" . vertico-repeat)
    :config
    (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)))

;; A very simple alternative to more involved SessionManagement solutions.
(use-package savehist
  :config
  (savehist-mode 1))

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

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:
  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(provide 'init-completion)
