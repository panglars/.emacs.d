;;; -*- lexical-binding:t; -*-

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(awk bash bibtex c-sharp commonlisp css dart dockerfile elixir go gomod heex html java javascript json julia kotlin latex lua make markdown proto r ruby rust toml tsx typescript typst verilog vhdl yaml))
  (treesit-auto-add-to-auto-mode-alist 'treesit-auto-langs)
  (setq my-typst-tsauto-config
        (make-treesit-auto-recipe
         :lang 'typst 
         :ts-mode 'typst-ts-mode
         :remap '(typst-mode)
         :url "https://github.com/uben0/tree-sitter-typst"
         :revision "master"
         :source-dir "src"
         :ext "\\.typ$"))
  (setq my-astro-tsauto-config
        (make-treesit-auto-recipe
         :lang 'astro
         :ts-mode 'astro-ts-mode
         :url "https://github.com/virchau13/tree-sitter-astro"
         :revision "master"
         :source-dir "src"))
  (add-to-list 'treesit-auto-recipe-list my-astro-tsauto-config)
  (add-to-list 'treesit-auto-recipe-list my-typst-tsauto-config)
  (global-treesit-auto-mode))

;; https://www.masteringemacs.org/article/combobulate-bulk-editing-treesitter-nodes-multiple-cursors
(use-package combobulate
  :disabled
  :custom (combobulate-key-prefix "C-c h")
  :hook ((prog-mode . combobulate-mode)))

;;; typst
(use-package typst-ts-mode
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode" :files (:defaults "*.el") :build (:not compile)))

;;; astro
(use-package astro-ts-mode)


(provide 'init-treesitter)
