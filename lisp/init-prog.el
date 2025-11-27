;; -*- lexical-binding: t; -*-

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

;; Other language
(use-package lua-mode)

(use-package clojure-mode)

(use-package zig-mode)

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))

(use-package just-mode
  :disabled)


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

