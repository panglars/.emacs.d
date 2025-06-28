;;; -*- lexical-binding:t; -*-

(use-package org
  :straight(:type built-in)
  :bind (("C-c a" . org-agenda)
         ("C-c C" . org-capture))
  
  :config
  (setq org-modules '(org-habit)
        org-directory my-org-directory
        org-capture-templates
        `(("w" "Work" entry (file+headline ,(concat org-directory "/work.org") "Work")
           "* TODO %?\nDEADLINE: %^t\n" :empty-lines 1)
          ("e" "Event" entry (file+headline ,(concat org-directory "/work.org") "Event")
           "* TODO %?\nSCHEDULED: %^t\n" :empty-lines 1)
          ("s" "School" entry (file+headline ,(concat org-directory "/school.org") "School")
           "* TODO %?\nDEADLINE: %^t\n" :empty-lines 1)
          ("t" "TODO" entry (file+headline ,(concat org-directory "/inbox.org") "Todo")
           "* TODO %?\n" :empty-lines 1)
          ("m" "Misc" entry (file+headline ,(concat org-directory "/inbox.org") "Misc")
           "* TODO %?\n" :empty-lines 1)
          ("f" "Flag" entry (file ,(concat org-directory "/flag.org"))
           "* TODO %?\n" :empty-lines 1)
          ("n" "Note" entry (file+headline ,(concat org-directory "/inbox.org") "Note")
           "* %? %^G\n%U" :empty-lines 1)
          ("j" "Journal" entry(file+datetree ,(concat org-directory "/journal.org"))
           "* %<%R> %?" :tree-type week)
          ("J" "Journal other day" entry(file+datetree ,(concat org-directory "/journal.org"))
           "* %?" :tree-type week :time-prompt t)
          )
        org-todo-keywords
        '((sequence "TODO(t)" "HOLD(h)" "STARTED(s)" "|" "DONE(d)" "FAILED(f)" "CANCEL(c)"))
        org-tags-column -80
        org-log-done 'time
        org-fold-catch-invisible-edits 'smart
        org-startup-indented t
        org-ellipsis (if (char-displayable-p ?⏷) "\t⏷" nil)
        org-pretty-entities nil
        org-hide-emphasis-markers t)
  
;;; Agenda 
  (setq
   org-agenda-time-leading-zero t
   org-agenda-files (list my-org-directory)
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ───────────────────────────────────────────────"
   )

  ;; Add new template
  (add-to-list 'org-structure-template-alist '("n" . "note"))


  ;; Add md/gfm backends
  (add-to-list 'org-export-backends 'md)
  (use-package ox-gfm
    :init (add-to-list 'org-export-backends 'gfm))

  ;; Prettify UI
  (use-package org-modern
    :init
    (setq org-modern-star ["➤" "✦" "✜" "✲" "✸" "❅"])
    :hook ((org-mode . org-modern-mode)
           (org-agenda-finalize . org-modern-agenda)
           (org-modern-mode . (lambda ()
                                "Adapt `org-modern-mode'."
                                ;; Disable Prettify Symbols mode
                                (setq prettify-symbols-alist nil)
                                (prettify-symbols-mode -1)))))
  (use-package org-fancy-priorities
    :disabled
    :hook (org-mode . org-fancy-priorities-mode)
    :init (setq org-fancy-priorities-list
                '("A" "B" "C" "D")))

  ;; Babel
  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t)
  
  (defconst load-language-alist
    '((emacs-lisp . t)
      (python     . t)
      (ruby       . t)
      (js         . t)
      (css        . t)
      (C          . t)
      (java       . t))
    "Alist of org ob languages.")

  (org-babel-do-load-languages 'org-babel-load-languages
                               load-language-alist)

  ;; Rich text clipboard
  (use-package org-rich-yank
    :bind (:map org-mode-map
                ("C-M-y" . org-rich-yank)))

  ;; Export text/html MIME emails
  (use-package org-mime
    :bind (:map message-mode-map
                ("C-c M-o" . org-mime-htmlize)
                :map org-mode-map
                ("C-c M-o" . org-mime-org-buffer-htmlize)))

  ;; Add graphical view of agenda
  (use-package org-timeline
    :hook (org-agenda-finalize . org-timeline-insert-timeline))

  ;; Pomodoro
  (use-package org-pomodoro
    :custom-face
    (org-pomodoro-mode-line ((t (:inherit warning))))
    (org-pomodoro-mode-line-overtime ((t (:inherit error))))
    (org-pomodoro-mode-line-break ((t (:inherit success))))
    :bind (:map org-mode-map
                ("C-c C-x m" . org-pomodoro))
    :init
    (with-eval-after-load 'org-agenda
      (bind-keys :map org-agenda-mode-map
                 ("K" . org-pomodoro)
                 ("C-c C-x m" . org-pomodoro)))))

;;; roam
(use-package org-roam
  :straight (org-roam :type git :host github :repo "org-roam/org-roam")
  :bind (
         ("C-c n a" . org-roam-alias-add)
         ("C-c n c" . org-roam-capture)
         ;; ("C-c n d" . org-roam-dailies-capture-today)
         ("C-c n f" . org-roam-node-find)
         ;; ("C-c n g" . org-roam-dailies-goto-date)
         ("C-c n i" . org-roam-node-insert)
         ;; ("C-c n j" . org-roam-dailies-capture-date)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n R" . org-roam-tag-remove)
         ("C-c n t" . org-roam-tag-add)
         ;; ("C-c n y" . org-roam-dailies-capture-yesterday)
         )
  :custom
  (org-roam-directory (file-truename my-org-roam-directory))
  :config
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:15}" 'face 'org-tag)))
  (setq
   org-roam-dailies-capture-templates
   '(("d" "default" entry "** %?" :if-new
      (file+head+olp "%<%G-%m>.org" "\n#+title: %<%G-%m>\n"
                     ("%<%Y.%m.%d %A>")))))
  (setq org-roam-capture-templates
        '(
          ("d" "Default" plain "%?"
           :target (file+head "%<%Y%m>-${slug}.org"
                              "#+title: ${title}\n")
           :unnarrowed t)
          ))
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :bind ("C-c n u" . org-roam-ui-mode))

(defun lan/remap-mode (mode)
  "make org-src-get-lang-mode respect major-mode-remap-alist"
  (treesit-auto--set-major-remap)
  (alist-get mode major-mode-remap-alist mode)
  )
(advice-add 'org-src-get-lang-mode :filter-return #'lan/remap-mode)


(provide 'init-org)
