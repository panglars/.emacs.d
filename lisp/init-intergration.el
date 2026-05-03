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

(use-package codex-ide
  :straight (:type git :host github :repo "dgillis/emacs-codex-ide")
  :bind ("C-c a" . codex-ide-menu))

;;;; terminal

(use-package ghostel
  :disabled
  :straight (ghostel :type git :host github :repo "dakra/ghostel" :bench "main")
  :bind(("<f10>" . ghostel)
        ("C-c t" . ghostel-project))
  :config
  (setq ghostel-tramp-shell-integration t)
  )

(use-package eat
  :straight (eat :type git
                 :host codeberg
                 :repo "akib/emacs-eat"
                 :files ("*.el" ("term" "term/*.el") "*.texi"
                         "*.ti" ("terminfo/e" "terminfo/e/*")
                         ("terminfo/65" "terminfo/65/*")
                         ("integration" "integration/*")
                         (:exclude ".dir-locals.el" "*-tests.el")))
  :config
  ;; Q to quit after process exit
  (add-hook 'eat-exit-hook 'view-mode)
  ;; eshell support
  (add-hook 'eshell-load-hook #'eat-eshell-mode)
  (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)

  ;; Integration with Meow
  (defun meomacs-eat-meow-setup ()
    (add-hook 'meow-normal-mode-hook 'eat-emacs-mode nil t)
    (add-hook 'meow-insert-mode-hook 'eat-char-mode nil t))
  (with-eval-after-load "meow"
    (with-eval-after-load "eat"
      (keymap-set eat-char-mode-map "C-S-v" 'eat-yank)
      (advice-add 'eat-semi-char-mode :after 'eat-emacs-mode)
      (add-hook 'eat-mode-hook 'meomacs-eat-meow-setup)))
  
  )

(provide 'init-intergration)
