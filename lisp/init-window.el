;;; -*- lexical-binding: t -*-

(use-package ace-window
  :defer t
  :bind ([remap other-window] . ace-window)
  :custom-face
  (aw-leading-char-face ((t (:inherit font-lock-keyword-face :bold t :height 3.0))))
  (aw-mode-line-face ((t (:inherit mode-line-emphasis :bold t))))
  :config
  (setq aw-keys '(?a ?r ?s ?t ?n ?e ?i ?o)
        aw-scope 'global
        aw-background t
        aw-minibuffer-flag t))

;; [winner] Restore old window configurations
(use-package winner
  :straight (:type built-in)
  :commands (winner-undo winner-redo)
  :init
  (setq winner-dont-bind-my-keys t)
  :hook (after-init . winner-mode)
  :config
  (setq winner-boring-buffers
        '("*Completions*" "*Compile-Log*" "*inferior-lisp*" "*Fuzzy Completions*"
          "*Apropos*" "*Help*" "*cvs*" "*Buffer List*" "*Ibuffer*"
          "*esh command on file*" "*which-key*")))

;; Enforce rules for popup windows
(use-package shackle
  :hook (after-init . shackle-mode)
  :config
  (setq shackle-default-size 0.4)
  )


(use-package popper
  :defines popper-echo-dispatch-actions
  :autoload popper-group-by-projectile
  :bind (("C-`"   . popper-toggle-latest)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (with-eval-after-load 'projectile
    (setq popper-group-function #'popper-group-by-projectile))
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$" "\\*Pp Eval Output\\*$"
          "\\*Compile-Log\\*"
          ;; "\\*Completions\\*"
          "\\*Warnings\\*"
          "\\*Async Shell Command\\*"
          "\\*Apropos\\*"
          "\\*Backtrace\\*"
          "\\*Calendar\\*"
          "\\*Embark Actions\\*"
          "\\*Finder\\*"
          "\\*Kill Ring\\*"
          "\\*Go-Translate\\*"
          "\\*xref\\*"

          bookmark-bmenu-mode
          comint-mode
          compilation-mode
          help-mode helpful-mode
          tabulated-list-mode
          Buffer-menu-mode

          flymake-diagnostics-buffer-mode
          flycheck-error-list-mode flycheck-verify-mode

          gnus-article-mode devdocs-mode
          grep-mode occur-mode rg-mode deadgrep-mode ag-mode pt-mode
          ivy-occur-mode ivy-occur-grep-mode
          youdao-dictionary-mode osx-dictionary-mode fanyi-mode

          "^\\*Process List\\*" process-menu-mode
          list-environment-mode cargo-process-mode

          "^\\*eshell.*\\*.*$"       eshell-mode
          "^\\*shell.*\\*.*$"        shell-mode
          "^\\*terminal.*\\*.*$"     term-mode
          ;; "^\\*vterm[inal]*.*\\*.*$" vterm-mode

          "\\*DAP Templates\\*$" dap-server-log-mode
          "\\*ELP Profiling Restuls\\*" profiler-report-mode
          "\\*Paradox Report\\*$" "\\*package update results\\*$" "\\*Package-Lint\\*$"
          "\\*[Wo]*Man.*\\*$"
          "\\*ert\\*$" overseer-buffer-mode
          "\\*gud-debug\\*$"
          "\\*lsp-help\\*$" "\\*lsp session\\*$"
          "\\*quickrun\\*$"
          "\\*gptel-quick\\*$"
          "\\*gt-result\\*$"
          "\\*eldoc\\*$"
          "\\*apheleia-apheleia-npx-log\\*$"
          "\\*tldr\\*$"
          "\\*vc-.*\\*$"
          "^\\*elfeed-entry\\*$"
          "^\\*macro expansion\\**"
          
          "\\*Agenda Commands\\*" "\\*Org Select\\*" "\\*Capture\\*" "^CAPTURE-.*\\.org*"
          "\\*Gofmt Errors\\*$" "\\*Go Test\\*$" godoc-mode
          "\\*docker-.+\\*"
          "\\*prolog\\*" inferior-python-mode inf-ruby-mode swift-repl-mode
          "\\*rustfmt\\*$" rustic-compilation-mode rustic-cargo-clippy-mode
          rustic-cargo-outdated-mode rustic-cargo-run-mode rustic-cargo-test-mode))
  (with-eval-after-load 'projectile
    (setq popper-group-function #'popper-group-by-projectile))

  :config
  (popper-mode 1)
  (popper-echo-mode 1)

  ;; ;; HACK: close popper with `C-g'
  ;; (defun +popper-close-window-hack (&rest _)
  ;;   "Close popper window via `C-g'."
  ;;   (when (and (called-interactively-p 'interactive)
  ;;              (not (region-active-p))
  ;;              popper-open-popup-alist)
  ;;     (let ((window (caar popper-open-popup-alist)))
  ;;       (when (window-live-p window)
  ;;         (delete-window window)))))
  ;; (advice-add #'keyboard-quit :before #'+popper-close-window-hack)
  )


;;; Ibuffer 
(use-package ibuffer
  :straight (:type built-in)
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode)
  :config
  (use-package nerd-icons-ibuffer)
  (use-package ibuffer-vc
    :disabled
    :commands (ibuffer-vc-set-filter-groups-by-vc-root)
    :custom
    (ibuffer-vc-skip-if-remote 'nil))
  
  :custom
  (ibuffer-expert t)
  (ibuffer-movement-cycle nil)
  (ibuffer-show-empty-filter-groups nil))

(provide 'init-window)
