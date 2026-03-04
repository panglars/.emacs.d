;;; -*- lexical-binding: t -*-;

(use-package rime
  :straight (rime :type git
                  :host github
                  :repo "DogLooksGood/emacs-rime"
                  :files ("*.el" "Makefile" "lib.c"))
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'posframe)
  :config
  ;; meow-mode hook
  (setq rime-disable-predicates
        '(meow-normal-mode-p
          meow-motion-mode-p
          meow-keypad-mode-p))
  (setq rime-posframe-properties
        (list :font "LXGW WenKai Screen-14"
              ;;  :internal-border-width 10
              ))
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime")
  :bind
  (:map rime-mode-map
        ("C-`" . 'rime-send-keybinding))
  )

(use-package pangu-spacing
  :config
  (global-pangu-spacing-mode 1)
  (let ((enable-pangu-spacing
         #'(lambda ()
             (set (make-local-variable 'pangu-spacing-real-insert-separtor) t))))
    (add-hook 'org-mode-hook enable-pangu-spacing)
    (add-hook 'markdown-mode-hook enable-pangu-spacing)))


(use-package gt
  :bind (("C-c k" . gt-translate))
  :config
  (setq gt-langs '(en zh))
  (setq gt-default-translator
        (gt-translator
         :taker   (gt-taker :text 'word :pick 'paragraph)       
         :engines (gt-google-engine)
         :render  (gt-buffer-render)))
  )

(provide 'init-chinese)
