;; JSON
(unless (fboundp 'js-json-mode)
  (use-package json-mode))

;; JavaScript
;; (use-package js2-mode
;;   :mode (("\\.js\\'" . js2-mode))
;;   :interpreter (("node" . js2-mode))
;;   :hook ((js2-mode . js2-imenu-extras-mode)
;;          (js2-mode . js2-highlight-unused-variables-mode))
;;   :config
;;                                         ;  (with-eval-after-load 'flycheck
;;                                         ;    (when (or (executable-find "eslint_d")
;;                                         ;              (executable-find "eslint")
;;                                         ;              (executable-find "jshint"))
;;                                         ;      (setq js2-mode-show-strict-warnings nil)))
;;   )

;; jsx
;; (use-package rjsx-mode
;;   :mode (("\\.jsx\\'" . rjsx-mode))
;;   )

;; typescript,tsx
;; (use-package typescript-mode
;;   :mode ("\\.ts[x]\\'" . typescript-mode))

(use-package treesit
  :straight (:type built-in)
  :mode (("\\.js\\'" . js-ts-mode)
         ("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  )


(use-package tide
  :after (typescript-mode flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; Run and interact with an inferior JS via js-comint.el
(use-package js-comint)

(provide 'init-javascript)
