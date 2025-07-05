;; -*- lexical-binding: t; -*- 
;;

(use-package rust-mode)

(use-package cargo-mode
  :hook
  (rust-mode . cargo-minor-mode)
  :config
  (setq compilation-scroll-output t))


(provide 'init-rust)
