;;; -*- lexical-binding:t; -*-

;; FIXME: https://github.com/tree-sitter/tree-sitter/issues/3296
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(awk bash bibtex c-sharp commonlisp css dart dockerfile elixir go gomod heex html java javascript json julia kotlin latex lua make markdown proto r ruby rust toml tsx typescript typst verilog vhdl yaml))
  (treesit-auto-add-to-auto-mode-alist 'treesit-auto-langs)
  (setq my/tsauto-config
        (make-treesit-auto-recipe
         :lang 'typst 
         :ts-mode 'typst-ts-mode
         :remap '(typst-mode)
         :url "https://github.com/uben0/tree-sitter-typst"
         :revision "master"
         :source-dir "src"
         :ext "\\.typ$"))
  (add-to-list 'treesit-auto-recipe-list my/tsauto-config)
  (global-treesit-auto-mode))

;;; typst
;; BUG: libgccjit error
(use-package typst-ts-mode
  :no-require
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode" :files (:defaults "*.el") :no-byte-compile t))

(provide 'init-treesitter)
