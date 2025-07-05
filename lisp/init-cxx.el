;; -*- lexical-binding: t; -*-
(use-package cc-mode
  :mode ("\\.h|\\.cpp" . c++-mode)
  :hook ((c-mode c++-mode) . lan/cxx-mode-setup)
  :bind (:map c++-mode-map
              ("C-c C-o" . ff-find-other-file))
  :init
  (setq cc-other-file-alist
        '(("\\.c\\'"   (".h"))
          ("\\.C\\'"   (".h" ".hpp" ".hxx"))
          ("\\.cc\\'"  (".h" ".hpp" ".hxx"))
          ("\\.cpp\\'" (".h" ".hpp" ".hxx"))
          ("\\.cxx\\'" (".h" ".hpp" ".hxx"))
          ("\\.tpp\\'" (".h" ".hpp" ".hxx"))
          ("\\.tcc\\'" (".h" ".hpp" ".hxx"))
          ("\\.h\\'"   (".tpp" ".cpp" ".cxx" ".tcc" ".cc" ".C" ".c" ".hxx" ".hpp"))
          ("\\.hpp\\'" (".tpp" ".cpp" ".cxx" ".tcc" ".cc" ".C" ".c" ".h"))
          ("\\.hxx\\'" (".tpp" ".cpp" ".cxx" ".tcc" ".cc" ".C" ".c" ".h"))))
  (defun lan/cxx-mode-setup ()
    (use-package modern-cpp-font-lock
      :diminish modern-c++-font-lock-mode
      :config
      (modern-c++-font-lock-global-mode t))

    (setq c-default-style "horstmann")
    ;; add horstmann style - copy bsd style
    (c-add-style "horstmann"
                 '("bsd"
                   (c-offsets-alist
                    (case-label . +))))
    (setq c-basic-offset 4)
    ;; don't mix tab and space indents
    (setq indent-tabs-mode nil)
    ;; don't change alignment of C type comments (fixes problem in JEdit)
    (c-set-offset 'c 'c-lineup-dont-change)
    ;; align a continued string under the one it continues
    (c-set-offset 'statement-cont 'c-lineup-string-cont)
    ;; align or indent after an assignment operator
    (c-set-offset 'statement-cont 'c-lineup-math)
    ;; align closing brace/paren with opening brace/paren
    (c-set-offset 'arglist-close 'c-lineup-close-paren)
    (c-set-offset 'brace-list-close 'c-lineup-close-paren)
    ;; align current argument line with opening argument line
    (c-set-offset 'arglist-cont-nonempty 'c-lineup-arglist)
    ;; don't change indent of java 'throws' statement in method declaration
    ;;     and other items after the function argument list
    (c-set-offset 'func-decl-cont 'c-lineup-dont-change)
    ;; set to NOT Indent Namespaces
    (c-set-offset  'namespace-open 0)
    (c-set-offset  'namespace-close 0)
    (c-set-offset  'innamespace 0)
    ;; used by ff-find-other-file
    (setq cc-search-directories '("."
                                  "../include"
                                  "../*/include"
                                  "/usr/include"
                                  "/usr/local/include/*"
                                  "../src"
                                  "../src/*"
                                  "../../src/*"
                                  "../../../src/*"
                                  "../../src/*/*"
                                  "../../../src/*/*/*"))))


(use-package cmake-mode
  :straight (:host github :repo "emacsmirror/cmake-mode" :files (:defaults "*"))
  :mode (("CMakeLists\\.txt$" . cmake-mode)
         ("\\.cmake$'" . cmake-mode))
  :config
  (setq cmake-tab-width 4)

  (use-package cmake-font-lock
    :config
    (add-hook 'cmake-mode-hook 'font-lock-refresh-defaults)))

(provide 'init-cxx)
