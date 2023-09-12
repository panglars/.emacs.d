(use-package rime
  :config
  (setq rime-disable-predicates
        '(meow-normal-mode-p
          meow-motion-mode-p
          meow-keypad-mode-p))
  (setq rime-posframe-properties
        (list :font "LXGW WenKai Screen-14"
              :internal-border-width 10
              ))
  :bind
  (:map rime-mode-map
        ("C-`" . 'rime-send-keybinding))
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'posframe)
  (rime-user-data-dir "~/.local/share/fcitx5/rime"))

(use-package pangu-spacing
  :init
  (global-pangu-spacing-mode 1)
  (add-hook 'org-mode-hook
            #'(lambda ()
                (set (make-local-variable 'pangu-spacing-real-insert-separtor) t))))

(provide 'init-chinese)
