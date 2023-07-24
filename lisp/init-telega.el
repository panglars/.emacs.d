(use-package telega
  :defer t
  :init
  (setq telega-emoji-use-images nil
        telega-auto-translate-probe-language-codes nil
        telega-translate-to-language-by-default "zh-CN"
        telega-chat-input-markups (list "org")
        )
  )

(provide 'init-telega)
