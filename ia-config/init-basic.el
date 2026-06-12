;;; init-basic.el --- Basic configuration for built-in features.  -*- lexical-binding: t; -*-

;;; Commentary:
;; 

(require 'init-common)

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

;;;; Completion
(setq completion-ignored-extensions nil) ;do not hide files in completion.

;;;; Keybindings
(keymap-unset global-map "C-x C-z" 'suspend-frame)
(keymap-global-unset "C-z" 'suspend-frame)


(provide 'init-basic)
;;; init-basic.el ends here
