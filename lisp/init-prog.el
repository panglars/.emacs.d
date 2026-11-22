;;; init-prog.el --- Languages, diagnostics and development tools -*- lexical-binding: t; -*-

;;; Languages

;;;; Clojure
(use-package clojure-mode)

(use-package cider)

;;;; Python
(use-package python
  :straight (:type built-in)
  :init
  (setq python-indent-offset 4
        python-fill-docstring-style 'django
        python-indent-guess-indent-offset nil
        python-shell-completion-native-enable nil))

;;;; Rust
(use-package cargo-mode
  :hook
  ((rust-mode rust-ts-mode) . cargo-minor-mode)
  :config
  (setq compilation-scroll-output t))

;;;; Web
(use-package web-mode
  :mode (("\\.\\(phtml\\|php\\|[gj]sp\\|as[cp]x\\|erb\\|djhtml\\|html?\\|hbs\\|ejs\\|jade\\|swig\\|tm?pl\\|vue\\)$" . web-mode)
         ("\\.astro\\'" . astro-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  ;; ASTRO
  (define-derived-mode astro-mode web-mode "Astro")
  )

(use-package zig-mode)

;;;; Common Lisp
(use-package slime
  :disabled
  :config (setq inferior-lisp-program "/usr/bin/sbcl"))

;;;; Treesitter
(use-package treesit
  :straight (:type built-in)
  :demand t
  :config
  (let ((excluded-modes '(c-ts-mode
                          c++-ts-mode
                          c-or-c++-ts-mode
                          cmake-ts-mode
                          )))
    ;; use classic major modes
    (setopt treesit-auto-install-grammar 'ask
            treesit-enabled-modes
            (seq-remove
             (lambda (mode) (memq mode excluded-modes))
             (delete-dups
              (mapcar #'cdr treesit-major-mode-remap-alist))))))

;;;; Typst
(use-package typst-ts-mode
  :straight (:type git :host codeberg :repo "meow_king/typst-ts-mode" :branch "main")
  :custom
  (typst-ts-watch-options "--open")
  (typst-ts-mode-grammar-location (expand-file-name "tree-sitter/libtree-sitter-typst.so" user-emacs-directory))
  (typst-ts-mode-enable-raw-blocks-highlight t)
  :config
  (keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu))


;;;; Markdown
(use-package markdown-ts-mode
  :straight (:type built-in)
  :mode ("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\|mdx\\)\\'" . markdown-ts-mode))

;; CSV highlight
(use-package rainbow-csv
  :straight (:host github :repo "emacs-vs/rainbow-csv"))

;; preview color in buffer
(use-package colorful-mode
  :hook (prog-mode text-mode))

;;;; C and C++

(use-package cc-mode
  :mode ("\\.h|\\.cpp" . c++-mode)
  :hook ((c-mode c++-mode) . lan/cxx-mode-setup)
  :bind (:map c++-mode-map
              ("C-c C-o" . ff-find-other-file))
  :init
  (setq cc-other-file-alist
        '(("\\.c\\'"   (".h"))
          ("\\.C\\'"   (".h" ".hpp" ".hxx"))
          ("\\.cc\\'"  (".h" ".hpp" ".hxx"))
          ("\\.cpp\\'" (".h" ".hpp" ".hxx"))
          ("\\.cxx\\'" (".h" ".hpp" ".hxx"))
          ("\\.tpp\\'" (".h" ".hpp" ".hxx"))
          ("\\.tcc\\'" (".h" ".hpp" ".hxx"))
          ("\\.h\\'"   (".tpp" ".cpp" ".cxx" ".tcc" ".cc" ".C" ".c" ".hxx" ".hpp"))
          ("\\.hpp\\'" (".tpp" ".cpp" ".cxx" ".tcc" ".cc" ".C" ".c" ".h"))
          ("\\.hxx\\'" (".tpp" ".cpp" ".cxx" ".tcc" ".cc" ".C" ".c" ".h"))))
  (defun lan/cxx-mode-setup ()
    (use-package modern-cpp-font-lock
      :diminish modern-c++-font-lock-mode
      :config
      (modern-c++-font-lock-global-mode t))

    (setq c-default-style "horstmann")
    ;; add horstmann style - copy bsd style
    (c-add-style "horstmann"
                 '("bsd"
                   (c-offsets-alist
                    (case-label . +))))
    (setq c-basic-offset 4)
    ;; don't mix tab and space indents
    (setq indent-tabs-mode nil)
    ;; don't change alignment of C type comments (fixes problem in JEdit)
    (c-set-offset 'c 'c-lineup-dont-change)
    ;; align a continued string under the one it continues
    (c-set-offset 'statement-cont 'c-lineup-string-cont)
    ;; align or indent after an assignment operator
    (c-set-offset 'statement-cont 'c-lineup-math)
    ;; align closing brace/paren with opening brace/paren
    (c-set-offset 'arglist-close 'c-lineup-close-paren)
    (c-set-offset 'brace-list-close 'c-lineup-close-paren)
    ;; align current argument line with opening argument line
    (c-set-offset 'arglist-cont-nonempty 'c-lineup-arglist)
    ;; don't change indent of java 'throws' statement in method declaration
    ;;     and other items after the function argument list
    (c-set-offset 'func-decl-cont 'c-lineup-dont-change)
    ;; set to NOT Indent Namespaces
    (c-set-offset  'namespace-open 0)
    (c-set-offset  'namespace-close 0)
    (c-set-offset  'innamespace 0)
    ;; used by ff-find-other-file
    (setq cc-search-directories '("."
                                  "../include"
                                  "../*/include"
                                  "/usr/include"
                                  "/usr/local/include/*"
                                  "../src"
                                  "../src/*"
                                  "../../src/*"
                                  "../../../src/*"
                                  "../../src/*/*"
                                  "../../../src/*/*/*"))))


(use-package cmake-mode
  :straight (:host github :repo "emacsmirror/cmake-mode" :files (:defaults "*"))
  :mode (("CMakeLists\\.txt$" . cmake-mode)
         ("\\.cmake$'" . cmake-mode))
  :config
  (setq cmake-tab-width 4)

  (use-package cmake-font-lock
    :config
    (add-hook 'cmake-mode-hook 'font-lock-refresh-defaults)))

;;; Diagnostics and formatting

(use-package flycheck
  :hook ((after-init . global-flycheck-mode)
         (after-init . global-flycheck-annotate-mode))
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error))
  :custom
  (flycheck-global-modes
   '(not outline-mode fundamental-mode lisp-interaction-mode
         diff-mode shell-mode eshell-mode term-mode vterm-mode))
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-display-errors-delay 0.5)
  (flycheck-check-syntax-automatically '(save mode-enabled))
  (flycheck-annotate-current-line-style 'eol)
  (flycheck-annotate-other-lines-style 'eol)
  (flycheck-eglot-exclusive nil)
  (flycheck-lsp-exclusive t)
  :config
  (setq-default flycheck-disabled-checkers
                '(emacs-lisp-checkdoc))
  (global-flycheck-eglot-mode 1)
  (global-flycheck-lsp-mode 1))

(use-package xref
  :hook ((xref-after-return xref-after-jump) . recenter)
  :custom
  (xref-search-program (cond ((executable-find "rg") 'ripgrep)
                             ((executable-find "ugrep") 'ugrep)
                             (t 'grep)))
  )

;; formatter
(use-package apheleia
  :config
  (apheleia-global-mode +1))

(use-package aggressive-indent-mode
  :defer t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

;;; Language servers

(use-package eglot
  :straight (:type built-in)
  :hook (((c-mode c-ts-mode
                  c++-mode c++-ts-mode
                  clojure-mode
                  python-mode python-ts-mode
                  rust-mode rust-ts-mode
                  js-mode js-ts-mode
                  typescript-mode typescript-ts-mode tsx-ts-mode
                  astro-mode
                  typst-ts-mode)
          . eglot-ensure))
  :init
  (setq eglot-extend-to-xref t
        eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5)
  :config
  (add-to-list 'eglot-server-programs
               '(astro-mode . ("astro-ls" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(typst-ts-mode . ("tinymist" "lsp")))

  ;; rust-analyzer extensions
  (use-package eglot-x
    :straight (:host github :repo "nemethf/eglot-x")
    :config
    (eglot-x-setup)))

;;; Development tools

(use-package vlf)

(use-package devdocs
  :bind
  ("C-h d" . devdocs-lookup))

;; to highlight dev docs
(use-package shrface
  :defer t
  :config
  (shrface-basic)
  (shrface-trial)
  (shrface-default-keybindings)
  (setq shrface-href-versatile t))

;; show assembly
(use-package rmsbolt
  :defer t)

(use-package quickrun
  :custom
  (quickrun-timeout-seconds 60)
  :bind
  (("<f5>" . quickrun)
   ("M-<f5>" . quickrun-shell)))


(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :custom
  (yas-use-menu nil)
  :config
  (with-eval-after-load 'init-completion
    (add-hook 'yas-keymap-disable-hook
              (lambda ()
                (when-let* ((frame (bound-and-true-p corfu--frame)))
                  (and (frame-live-p frame) (frame-visible-p frame))))))

  (setq yas-inhibit-overlay-modification-protection t)
  (advice-add 'yas--on-protection-overlay-modification :override #'ignore))

;;; Completion integrations

(with-eval-after-load 'init-completion
  (use-package consult-flycheck
    :bind ("C-c j" . consult-flycheck))

  (use-package consult-eglot
    :bind (:map eglot-mode-map
                ("C-M-." . consult-eglot-symbols))))

(provide 'init-prog)

;;; init-prog.el ends here
