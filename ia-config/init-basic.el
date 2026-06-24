;;; init-basic.el --- Basic configuration for built-in features.  -*- lexical-binding: t; -*-

;;; Commentary:
;; Setting basic features that do not require third-party packages,
;; and before requiring `init-package-install'.
;; More complicated settings should be in specific `init-' files.

(require 'ia-core-utility)

;;; Code:

;;;; Appearance
(setq inhibit-splash-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(set-scroll-bar-mode nil)
(setq custom-file "~/.emacs.d/custom.el")
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)
(setq display-line-numbers-width-start t)
(setq display-line-numbers-type 'relative)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq mouse-wheel-progressive-speed nil)
(setq blink-cursor-interval 0.28)
(setq blink-cursor-delay 0)
(setq blink-cursor-blinks -1)
(setq use-file-dialog nil)

;;;; Mode Line
(column-number-mode +1)

;;;; History
(savehist-mode +1)

;;;; File saving and tracking
(save-place-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)
;; Backup management
;; https://old.reddit.com/r/emacs/comments/15wr8xu/emacs_291_as_ide_for_python/
(setq backup-directory-alist '(("." . "~/.emacsVisitedFileBckps"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 2   ;keep N versions of original file undeleted
      )
(setq delete-by-moving-to-trash t)

;;;; In-buffer operation & Edition
;; enable camelCase sensitivity when killing a word.
(subword-mode +1)
(setopt hscroll-step 1)
(setopt hscroll-margin 10)

;;;; Completion
(setq completion-ignored-extensions nil) ;do not hide files in completion.
;; like marginalia-mode but only for some minibuffers
(setq completions-detailed t)

;;;; Keybindings
(keymap-unset global-map "C-x C-z" 'suspend-frame)
(keymap-global-unset "C-z" 'suspend-frame)


(provide 'init-basic)
;;; init-basic.el ends here
