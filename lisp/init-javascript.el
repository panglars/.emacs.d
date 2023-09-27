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


(provide 'init-javascript)
