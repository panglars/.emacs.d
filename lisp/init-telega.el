(use-package telega
  :straight (telega :type git :host github :repo "zevlg/telega.el" :branch "release-0.8.0")
  :init
  (add-hook 'telega-load-hook
	        (lambda ()
	          (define-key global-map (kbd "C-c k") telega-prefix-map)))

  (setq telega-emoji-use-images nil
        telega-auto-translate-probe-language-codes nil
        telega-translate-to-language-by-default "zh-CN"
        telega-chat-input-markups (list "org")
        )
  :hook
  (telega-load-hook . telega-notifications-mode)
  (telega-load-hook . telega-appindicator-mode)
  (telega-load-hook . telega-mode-line-mode))

(provide 'init-telega)
