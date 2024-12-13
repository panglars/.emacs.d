;;; init-count.el --- 
(use-package beancount
  :disabled
  :straight (beancount :type git :host github :repo "beancount/beancount-mode")
  :mode ("\\.beancount\\'" . beancount-mode))

(provide 'init-count)
