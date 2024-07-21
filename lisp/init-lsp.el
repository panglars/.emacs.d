;;; -*- lexical-binding:t; -*-

;;; lsp-bridge


;;; lsp-mode

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
  ("C-c l h" . lsp-describe-thing-at-point)
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
    :disabled
    :custom
    (lsp-metals-enable-semantic-highlighting t))
  
  ;; typst lsp
  (add-to-list 'lsp-language-id-configuration
               '("\\.typ$" . "typst"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection (lambda () (executable-find "tinymist")))
    :major-modes '(typst-mode typst-ts-mode)
    :server-id 'tinymist))


  ;; Enable LSP in org babel 
  (cl-defmacro lsp-org-babel-enable (lang)
    "Support LANG in org source code block."
    (cl-check-type lang string)
    (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
           (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
      `(progn
         (defun ,intern-pre (info)
           (setq buffer-file-name (or (->> info caddr (alist-get :file))
                                      "org-src-babel.tmp"))
           ;; Directly use lsp-mode
           (when (fboundp 'lsp-deferred)
             ;; Avoid headerline conflicts
             (setq-local lsp-headerline-breadcrumb-enable nil)
             (lsp-deferred)))
         (put ',intern-pre 'function-documentation
              (format "Enable `lsp-mode' in the buffer of org source block (%s)."
                      (upcase ,lang)))

         (if (fboundp ',edit-pre)
             (advice-add ',edit-pre :after ',intern-pre)
           (progn
             (defun ,edit-pre (info)
               (,intern-pre info))
             (put ',edit-pre 'function-documentation
                  (format "Prepare local buffer environment for org source block (%s)."
                          (upcase ,lang))))))))

  (defconst org-babel-lang-list
    '("go" "python" "ipython" "ruby" "js" "css" "sass" "c" "rust" "java" "cpp" "c++"))
  (add-to-list 'org-babel-lang-list "shell")
  (dolist (lang org-babel-lang-list)
    (eval `(lsp-org-babel-enable ,lang)))

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
