;;; init-prog.el --- Measure startup and require times -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package vlf)

;; Python
(use-package python
  :straight (:type built-in)
  :mode ("\\.py\\'" . python-mode)
  :init
  (setq python-indent-offset 4
        python-fill-docstring-style 'django
        python-indent-guess-indent-offset nil
        python-shell-completion-native-enable nil))

;; Rust
(use-package rust-mode)

(use-package cargo-mode
  :hook
  (rust-mode . cargo-minor-mode)
  :config
  (setq compilation-scroll-output t))

;; Go
(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :config
  (use-package go-tag
    :init (setq go-tag-args (list "-transform" "camelcase"))))

(use-package gotest
  :init
  (setq go-test-verbose t))

;; Web
(use-package web-mode
  :mode "\\.\\(phtml\\|php\\|[gj]sp\\|as[cp]x\\|erb\\|djhtml\\|html?\\|hbs\\|ejs\\|jade\\|swig\\|tm?pl\\|vue\\|astro\\)$"
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  ;; ASTRO
  (define-derived-mode astro-mode web-mode "astro")
  )

;; Other language
(use-package lua-mode)

(use-package clojure-mode)

(use-package zig-mode)

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))

(use-package just-mode
  :disabled)

;; Treesitter
(use-package treesit
  :straight (:type built-in)
  :commands (+treesit-install-all-languages)
  :config
  (setq treesit-language-source-alist
        '((rust          . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (toml          . ("https://github.com/tree-sitter/tree-sitter-toml"))
          ;; (haskell       . ("https://github.com/tree-sitter/tree-sitter-haskell"))
          ;; (bibtex        . ("https://github.com/latex-lsp/tree-sitter-bibtex"))
          ;; (cmake         . ("https://github.com/uyha/tree-sitter-cmake"))
          (css           . ("https://github.com/tree-sitter/tree-sitter-css"))
          ;; (dockerfile    . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
          (html          . ("https://github.com/tree-sitter/tree-sitter-html"))
          (java          . ("https://github.com/tree-sitter/tree-sitter-java"))
          (javascript    . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (jsdoc         . ("https://github.com/tree-sitter/tree-sitter-jsdoc"))
          (json          . ("https://github.com/tree-sitter/tree-sitter-json"))
          (latex         . ("https://github.com/latex-lsp/tree-sitter-latex"))
          ;; (make          . ("https://github.com/tree-sitter-grammars/tree-sitter-make"))
          ;; (lua           . ("https://github.com/tree-sitter-grammars/tree-sitter-lua"))
          ;; (org           . ("https://github.com/milisims/tree-sitter-org"))
          ;; (python        . ("https://github.com/tree-sitter/tree-sitter-python"))
          (sql           . ("https://github.com/DerekStride/tree-sitter-sql"))
          (typescript    . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src"))
          (tsx           . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src"))
          (vue           . ("https://github.com/tree-sitter-grammars/tree-sitter-vue"))
          (yaml          . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml"))
          ;; (markdown      . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
          ;; (markdown-inline . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src"))
          ))

  (defun +treesit-install-all-languages ()
    "Install all languages specified by `treesit-language-source-alist'."
    (interactive)
    (let ((languages (mapcar 'car treesit-language-source-alist)))
      (dolist (lang languages)
        (treesit-install-language-grammar lang)
        (message "`%s' parser was installed." lang)
        (sit-for 0.75)))))

;; typst
(use-package typst-ts-mode
  :straight (:type git :host codeberg :repo "meow_king/typst-ts-mode" :branch "main")
  :custom
  (typst-ts-watch-options "--open")
  (typst-ts-mode-grammar-location (expand-file-name "tree-sitter/libtree-sitter-typst.so" user-emacs-directory))
  (typst-ts-mode-enable-raw-blocks-highlight t)
  :config
  (keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu))


;; Markdown
(use-package markdown-mode
  :mode ("README\\(_zh\\)?\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; CSV highlight
(use-package rainbow-csv
  :straight (:host github :repo "emacs-vs/rainbow-csv"))

;; preview color in buffer
(use-package colorful-mode
  :hook (prog-mode text-mode))

;;; Devdocs
(use-package devdocs
  :bind
  ("C-c S" . devdocs-lookup))

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

;; Pixel-perfect visual alignment for Org and Markdown tables
(use-package valign
  :hook (org-mode . valign-mode))

(use-package ast-grep
  :straight (:type git :host github :repo "SunskyXH/ast-grep.el"))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :custom
  (yas-use-menu nil)
  :config
  (add-hook 'yas-keymap-disable-hook
            (lambda ()
              (and (frame-live-p corfu--frame)
                   (frame-visible-p corfu--frame))))

  (setq yas-inhibit-overlay-modification-protection t)
  (advice-add 'yas--on-protection-overlay-modification :override #'ignore))

(provide 'init-prog)

