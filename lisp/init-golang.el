;; -*- lexical-binding: t; -*-
(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :config
  (use-package go-tag
    :init (setq go-tag-args (list "-transform" "camelcase"))))

(use-package gotest
  :init
  (setq go-test-verbose t))

(provide 'init-golang)
