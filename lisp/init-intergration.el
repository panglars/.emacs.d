;;; init-intergration.el --- 

(use-package wakatime-mode
  :init (global-wakatime-mode))

;; Discord rich presence
(use-package elcord)

(use-package telega
  :straight (telega :type git :host github :repo "zevlg/telega.el" :branch "master")
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

;;  bi-directional editing in online text editors and text areas from within Emacs
(use-package atomic-chrome
  :demand t
  :straight (atomic-chrome
             :repo "KarimAziev/atomic-chrome"
             :type git
             :host github)
  :commands (atomic-chrome-start-server)
  :config
  (setq-default atomic-chrome-buffer-open-style 'frame)
  (setq-default atomic-chrome-auto-remove-file t)
  (setq-default atomic-chrome-extension-type-list '(atomic-chrome))
  (atomic-chrome-start-server))

(provide 'init-intergration)
