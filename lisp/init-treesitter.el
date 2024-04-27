;;; init-treesitter.el ---
;; FIXME: https://github.com/tree-sitter/tree-sitter/issues/3296
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(awk bash bibtex c-sharp commonlisp css dart dockerfile elixir go gomod heex html java javascript json julia kotlin latex lua make markdown proto r ruby rust toml tsx typescript typst verilog vhdl yaml))
  (treesit-auto-add-to-auto-mode-alist 'treesit-auto-langs)
  (global-treesit-auto-mode))

(use-package typst-ts-mode
  :disabled
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode")
  :custom
  (typst-ts-mode-watch-options "--open"))


(provide 'init-treesitter)
