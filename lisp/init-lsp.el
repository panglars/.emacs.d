;;; -*- lexical-binding:t; -*-

;; lsp-bridge
(use-package lsp-bridge
  :disabled
  :straight '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge"
                         :files (:defaults "*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
                         :build (:not compile))
  :bind
  (("C-c l d" . lsp-bridge-find-def)
   ("C-c l D" . lsp-bridge-find-def-other-window)
   ("C-c l b" . lsp-bridge-find-def-return)
   ("C-c l i" . lsp-bridge-find-impl)
   ("C-c l I" . lsp-bridge-find-impl-other-window)
   ("C-c l t" . lsp-bridge-find-type-def)
   ("C-c l T" . lsp-bridge-find-type-def-other-window)
   ("C-c l r" . lsp-bridge-find-references)
   ("C-c l E" . lsp-bridge-popup-documentation)
   ("C-c l n" . lsp-bridge-rename)
   ("C-c l e" . lsp-bridge-diagnostic-list)
   ("C-c l a" . lsp-bridge-code-action)
   ("C-c l f" . lsp-bridge-signature-help-fetch)
   ("C-c l p" . lsp-bridge-peek)
   :map lsp-bridge-ref-mode-map
   ("C-n" . lsp-bridge-ref-jump-next-keyword)
   ("C-p" . lsp-bridge-ref-jump-prev-keyword)
   ("N" . lsp-bridge-ref-jump-next-file)
   ("P" . lsp-bridge-ref-jump-prev-file)
   )

  :hook (astro-ts-mode . lsp-bridge-mode)
  :init
  (global-lsp-bridge-mode)
  ;; :config
  ;; (add-to-list 'lsp-bridge-default-mode-hooks 'astro-ts-mode-hook)
  )

;; emacs-lsp-booster
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;; lsp-mode
(use-package lsp-mode
  :defer t
  :custom
  (lsp-completion-provider :none) ;; for corfu 
  :bind
  ("C-c l n" . lsp-rename)
  ("C-c l s" . lsp-ui-peek-find-workspace-symbol)
  ("C-c l d" . lsp-find-definition)
  ("C-c l i" . lsp-find-implementation)
  ("C-c l r" . lsp-find-references)
  ("C-c l h" . lsp-ui-doc-show)
  ("C-c l f" . lsp-format-buffer)
  ("C-c l F" . lsp-organize-imports)
  ("C-c l a" . lsp-execute-code-action)
  ("C-c l m" . lsp-ui-imenu)
  ("C-c l M" . lsp-ui-imenu--kill)
  ("C-c l t" . lsp-find-type-definition)
  ("C-c l D" . lsp-ui-peek-find-definitions)
  ("C-c l I" . lsp-ui-peek-find-implementation)
  ("C-c l R" . lsp-ui-peek-find-references)

  :init
  (setq lsp-keymap-prefix "C-c C-e")
  (defun lan/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))) ;; Configure orderless
  ;; lsp-mode features
  (setq
   lsp-enable-symbol-highlighting nil
   lsp-lens-enable t
   lsp-signature-auto-activate nil
   lsp-headerline-breadcrumb-enable nil
   lsp-eldoc-render-all t
   lsp-signature-render-documentation nil
   lsp-progress-prefix "󱦟"
   lsp-semantic-tokens-enable t
   lsp-progress-spinner-type 'progress-bar-filled
   lsp-enable-folding nil
   lsp-enable-text-document-color nil
   lsp-enable-on-type-formatting nil
   lsp-modeline-code-actions-enable nil )
  :hook (
         (astro-ts-mode . lsp-deferred)
         (prog-mode . (lambda ()
                        (unless (derived-mode-p 'emacs-lisp-mode 'lisp-mode 'sh-mode 'makefile-mode)
                          (lsp-deferred))))
         (lsp-completion-mode . lan/lsp-mode-setup-completion)
         (lsp-mode . lsp-enable-which-key-integration))

  :config
  ;;; lsp-ui 
  (use-package lsp-ui
    :bind(("C-c u" . lsp-ui-imenu)
          :map lsp-ui-mode-map
          ("s-<return>" . lsp-ui-sideline-apply-code-actions))
    :hook (lsp-mode . lsp-ui-mode)
    :init
    (setq lsp-ui-sideline-show-diagnostics nil
          lsp-ui-sideline-ignore-duplicate t
          lsp-ui-doc-delay 0.1
          lsp-ui-doc-show-with-cursor nil
          ;; lsp-ui-doc-show-with-cursor (not (display-graphic-p))
          lsp-ui-imenu-auto-refresh 'after-save
          lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                                ,(face-foreground 'font-lock-string-face)
                                ,(face-foreground 'font-lock-constant-face)
                                ,(face-foreground 'font-lock-variable-name-face))))
  ;; tailwindcss lsp
  (use-package lsp-tailwindcss
    :init
    (setq lsp-tailwindcss-add-on-mode t))
  
  ;; python lsp 
  (use-package lsp-pyright
    :hook (python-mode . (lambda ()
                           (require 'lsp-pyright)
                           (lsp-deferred))))
  ;; scala lsp 
  (use-package lsp-metals
    :custom
    (lsp-metals-enable-semantic-highlighting t)
    :hook (scala-mode . lsp))
  
  ;; typst lsp
  (add-to-list 'lsp-language-id-configuration
               '("\\.typ$" . "typst"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection (lambda () (executable-find "tinymist")))
    :major-modes '(typst-mode typst-ts-mode)
    :server-id 'tinymist))

  (use-package consult-lsp
    :bind ("C-c l e" . consult-lsp-diagnostics))

  (use-package dap-mode
    :disabled
    :bind
    (:map dap-mode-map
          (("<f12>" . dap-debug)
           ("<f8>" . dap-continue)
           ("<f6>" . dap-next)
           ("<f7>" . dap-breakpoint-toggle)))
    :config
    ;; Enabling only some features
    (setq dap-auto-configure-features '(sessions locals controls tooltip))
    (require 'dap-node)
    (dap-node-setup) ;; Automatically installs Node debug adapter if needed
    (require 'dap-chrome)
    (dap-chrome-setup))
  )

;;; eglot 
(use-package eglot
  :disabled
  :straight (:type built-in)
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p 'emacs-lisp-mode 'lisp-mode 'makefile-mode 'snippet-mode 'fish-mode)
                          (eglot-ensure))))
         ((markdown-mode yaml-mode yaml-ts-mode) . eglot-ensure))
  :init
  (setq eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5)
  
  :config
  ;;  (add-to-list 'eglot-stay-out-of 'flymake)

  ;; for rust-analyzer extensions 
  (use-package eglot-x
    :straight (:host github :repo "nemethf/eglot-x")
    :config
    (eglot-x-setup))
  
  (use-package consult-eglot
    :bind (:map eglot-mode-map
                ("C-M-." . consult-eglot-symbols)))
  
  (use-package eglot-booster
    :disabled
    :straight (:host github :repo "jdtsmith/eglot-booster")
    :config	(eglot-booster-mode))

  (use-package flycheck-eglot
    :after (flycheck)
    :config
    (global-flycheck-eglot-mode 1)))


(provide 'init-lsp)
;;; init-lsp.el ends here
