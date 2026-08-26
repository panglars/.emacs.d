;;; init-prog.el --- Measure startup and require times -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package vlf)

;;;; clojure
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

;;;; rust
(use-package cargo-mode
  :hook
  ((rust-mode rust-ts-mode) . cargo-minor-mode)
  :config
  (setq compilation-scroll-output t))

;; Web
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

;; common lisp
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
(use-package markdown-ts-mode
  :straight (:type built-in)
  :mode ("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\|mdx\\)\\'" . markdown-ts-mode))

;; CSV highlight
(use-package rainbow-csv
  :straight (:host github :repo "emacs-vs/rainbow-csv"))

;; preview color in buffer
(use-package colorful-mode
  :hook (prog-mode text-mode))

;;;; Devdocs
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
  (add-hook 'yas-keymap-disable-hook
            (lambda ()
              (and (frame-live-p corfu--frame)
                   (frame-visible-p corfu--frame))))

  (setq yas-inhibit-overlay-modification-protection t)
  (advice-add 'yas--on-protection-overlay-modification :override #'ignore))


(provide 'init-prog)

;;; init-prog.el ends here
