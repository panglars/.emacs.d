;;; init-completion.el --- Completion, search and actions -*- lexical-binding: t; -*-

;;; In-buffer completion

;; https://github.com/minad/corfu/discussions/457
(setq text-mode-ispell-word-completion nil
      tab-always-indent 'complete
      read-extended-command-predicate #'command-completion-default-include-p)

(use-package corfu
  :straight (corfu :includes (corfu-quick) :files (:defaults "extensions/corfu-*.el"))
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-bar-width 0.5)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match 'separator)
  (corfu-min-width 20)
  (corfu-max-width 80)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-preview-current nil)
  (global-corfu-modes '((not shell-mode
                             eshell-mode
                             comint-mode
                             erc-mode
                             gud-mode
                             rcirc-mode
                             text-mode
                             minibuffer-inactive-mode)
                        t))
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-j" . corfu-reset)
              ("M-h" . corfu-info-documentation)
              ("C-g" . corfu-quit))
  :init
  (global-corfu-mode 1)
  :config
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
    :config
    (corfu-history-mode 1))
  (use-package corfu-popupinfo
    :straight nil
    :after corfu
    :demand t
    :bind (:map corfu-map
                ("M-p" . corfu-popupinfo-scroll-down)
                ("M-n" . corfu-popupinfo-scroll-up)
                ("M-d" . corfu-popupinfo-toggle))
    :custom
    (corfu-popupinfo-delay '(0.5 . 0.5))
    :config
    (corfu-popupinfo-mode 1)))

;; A bunch of completion at point extensions
(use-package cape
  :bind ("C-c P" . cape-prefix-map)
  :init
  ;; (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; `add-hook' prepends by default, so `cape-file' takes precedence.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

;;; Minibuffer completion

;; Emacs completion style
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion))))
  (completion-pcm-leading-wildcard t))

;; Vertical interactive completion
(use-package vertico
  :straight (vertico :includes (vertico-repeat)
                     :files (:defaults "extensions/vertico-*.el"))
  :hook (after-init . vertico-mode)
  :init
  (when after-init-time
    (vertico-mode 1))
  :config
  (setq vertico-resize nil
        vertico-count 15
        vertico-cycle t))

(use-package vertico-repeat
  :straight nil
  :after vertico
  :bind ("M-R" . vertico-repeat)
  :hook (minibuffer-setup . vertico-repeat-save))

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
  (marginalia-mode 1))

;;; Search and navigation

(use-package consult
  :bind(;; C-c bindings in `mode-specific-map'
        ("C-c M-x" . consult-mode-command)
        ("C-c b" . consult-buffer)
        ("C-c r" . consult-ripgrep)
        ("C-c f" . consult-fd)
        ("C-c i" . consult-imenu)
        ("C-c I" . consult-imenu-multi)
        ("C-c R" . consult-bookmark)            ;; orig. bookmark-jump
        ("C-c B" . consult-project-buffer)      ;; orig. project-switch-to-buffer
        ("C-x C-r" . consult-recent-file)
        ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
        ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
        ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
        ("M-#"   . consult-register-load)
        ("M-'"   . consult-register-store)        ;; orig. abbrev-prefix-mark (unrelated)
        ("C-M-#" . consult-register)
        ("M-y" . consult-yank-pop)                ;; orig. yank-pop
        )
  :init
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; [consult-dir] Insert path quickly in minibuffer
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

;;; Actions and annotations

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
  (nerd-icons-completion-mode 1)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

;;; Meow bindings

(with-eval-after-load 'init-editing
  (meow-leader-define-key '("/" . embark-act))
  (meow-normal-define-key '(";" . embark-act)
                          '("L" . consult-goto-line)))

(provide 'init-completion)

;;; init-completion.el ends here
