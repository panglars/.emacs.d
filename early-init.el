;;; early-init.el --- Early initialization -*- lexical-binding: t -*-

;; No need of package-quickstart since we are using straight.el as package manager
(setq package-quickstart nil)
;; Do not initialise the package manager. This is done in `init.el'.
(setq package-enable-at-startup nil)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(when (bound-and-true-p tooltip-mode) (tooltip-mode -1))
(setq-default frame-title-format '("%b  -  GNU Emacs"))

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we easily halve startup times with fonts that are
;; larger than the system default.
(setq frame-inhibit-implied-resize t)

;; Ignore X resources; its settings would be redundant with the other settings
;; in this file and can conflict with later config (particularly where the
;; cursor color is concerned).
(advice-add #'x-apply-session-resources :override #'ignore)

;; Make UTF-8 the default coding system:
(set-language-environment "UTF-8")

;; Use plists for deserialization
(setenv "LSP_USE_PLISTS" "true")


