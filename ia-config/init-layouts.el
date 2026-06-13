;;; init-layouts.el --- Window & Tab & Frame Configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(require 'init-common)

;;; Code:

(ia/feat-chunk ia-setup/window-management t
  (winner-mode +1)
  (windmove-mode +1)
  (global-tab-line-mode +1)

  ;; Do not make new windows to display buffers. Buffers that need to
  ;; pop up should be managed by `popper-mode'.
  (setq pop-up-windows nil)

  (ia/feat-chunk ia-setup/popper t
    (setq popper-display-control t)
    (setq popper-group-function 'popper-group-by-project)
    (setq popper-reference-buffers
          `("[Oo]utput\\*"
            "\\*Async Shell Command\\*"
            "\\*Backtrace\\*"
            "\\*Warnings\\*"
            "\\*eglot doc\\*"
            "\\*EGLOT.*events\\*"
            "\\*Async-native-compile-log\\*"
            "\\*ielm\\*"
            "\\*Ement members: Haskell\\*"
            "\\*Anaconda\\*"
            "\\*.+shell\\*"
            "\\*ghcid\\*"
            "\\*gt-result\\*"
            "\\*Elfeed-Tube Channels\\*"
            "\\*Diagram-collision-preview\\*"
            "\\*simple counter\\*"
            message-mode
            messages-buffer-mode
            occur-mode
            pdf-occur-buffer-mode
            Buffer-menu-mode
            help-mode
            ;; special-mode
            inferior-python-mode
            inferior-scheme-mode
            haskell-interactive-mode
            hs-lint-mode
            xref--xref-buffer-mode
            emacs-lisp-compilation-mode
            debugger-mode
            compilation-mode
            embark-collect-mode))
    (popper-mode +1)
    (popper-echo-mode +1)
    ;; defined in my `emacs-utils` repo.
    ;; (ia/popper-modified-mode +1)
    ))

(ia/feat-chunk ia-setup/tab-bar-management t
  (with-eval-after-load 'tab-bar
    (setq tab-bar-auto-width-max '((120) 20))
    (setq tab-bar-new-tab-choice 'scratch-buffer)
    (tab-bar-mode +1)
    (ia/tab-bar-setup-mode +1)))

(ia/feat-chunk ia-setup/ace-window t
  (with-eval-after-load 'ace-window
    (setq aw-dispatch-when-more-than 1
          aw-minibuffer-flag t)))

(provide 'init-layouts)

;;; init-layouts.el ends here
