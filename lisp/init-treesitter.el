;;; init-treesitter.el --- 
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (delete '(c cpp clojure) treesit-auto-langs)
  (setq treesit-auto-langs '(awk bash bibtex c-sharp commonlisp css dart dockerfile elixir go gomod heex html java javascript json julia kotlin latex lua make markdown proto r ruby rust toml tsx typescript typst verilog vhdl yaml))
  ;;(treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package typst-ts-mode
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode")
  :custom
  (typst-ts-mode-watch-options "--open"))


(provide 'init-treesitter)
