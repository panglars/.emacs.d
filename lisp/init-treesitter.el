;;; init-treesitter.el ---
;; FIXME: https://github.com/tree-sitter/tree-sitter/issues/3296
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(awk bash bibtex c-sharp commonlisp css dart dockerfile elixir go gomod heex html java javascript json julia kotlin latex lua make markdown proto r ruby rust toml tsx typescript typst verilog vhdl yaml))
  (treesit-auto-add-to-auto-mode-alist 'treesit-auto-langs)
  (global-treesit-auto-mode))

;;; typst 
(use-package typst-ts-mode
  :disabled
  :straight (:host sourcehut :repo "meow_king/typst-ts-mode" :files (:defaults "*.el"))
  ;; (optional) checking typst grammar version needs it
  (typst-ts-mode-grammar-location (expand-file-name "tree-sitter/libtree-sitter-typst.so" user-emacs-directory)))

(provide 'init-treesitter)
