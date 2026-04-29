;; -*- lexical-binding: t; -*- 

(use-package wakatime-mode
  :init (global-wakatime-mode))

;; Discord rich presence
(use-package elcord)

(use-package telega
  :disabled
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

;;;; LLM agent

(use-package pi-coding-agent
  :disabled
  :init (defalias 'pi 'pi-coding-agent)
  :bind (:map pi-coding-agent-chat-mode-map
              ("?" . pi-coding-agent-menu)
              ("P" . pi-coding-agent-previous-message)
              ("N" . pi-coding-agent-next-message))
  :custom
  (pi-coding-agent-tool-preview-lines 0)         ; Lines shown before collapsing tool output
  (pi-coding-agent-bash-preview-lines 1)          ; Lines shown for bash output
  (pi-coding-agent-visit-file-other-window t)     ; RET opens file in other window (nil for same)
  (pi-coding-agent-input-markdown-highlighting t)  ; tree-sitter markdown highlighting in input buffer
  )

;;;; terminal

(use-package ghostel
  :straight (ghostel :type git :host github :repo "dakra/ghostel" :bench "main"))


(provide 'init-intergration)
