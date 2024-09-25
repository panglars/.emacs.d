;;; -*- lexical-binding:t; -*-

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

;; https://www.masteringemacs.org/article/combobulate-bulk-editing-treesitter-nodes-multiple-cursors
(use-package combobulate
  :preface
  (setq combobulate-key-prefix "C-c j")
  :hook
  ((python-ts-mode . combobulate-mode)
   (js-ts-mode . combobulate-mode)
   (html-ts-mode . combobulate-mode)
   (css-ts-mode . combobulate-mode)
   (yaml-ts-mode . combobulate-mode)
   (typescript-ts-mode . combobulate-mode)
   (json-ts-mode . combobulate-mode)
   (tsx-ts-mode . combobulate-mode))
  )

;;; typst
(use-package typst-ts-mode
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode" :files (:defaults "*.el") :build (:not compile)))

(provide 'init-treesitter)
