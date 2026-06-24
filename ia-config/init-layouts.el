;;; init-layouts.el --- Window & Tab & Frame Configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(require 'ia-core-utility)

;;; Code:

(ia/feat-chunk ia-setup/window-management t
  ;; do not use `winner-mode' if you use `tab-bar-mode' and
  ;; `tab-bar-history-mode', it overrides `tab-bar-history-mode-map'
  ;; and pollutes per tab window history when called.
  ;; (winner-mode +1)
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
            "\\*eldoc\\*"
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
    ;; defined in my `emacs-utils' repo.
    (ia/popper-modified-mode +1))

  (with-eval-after-load 'ia-window-prefix-pivot
    ;; fix window prefix command to open new buffer in the mru window
    ;; if the current buffer is a dedicated window.
    (ia/window-prefix-pivot-mode +1)))

(ia/feat-chunk ia-setup/frame-management t
  (ia/feat-chunk ia-setup/desktop-save t
    (setopt desktop-path '("~/.emacs.d/desktop/"))
    (desktop-save-mode +1))

  (ia/feat-chunk ia-setup/tab-bar t
    (with-eval-after-load 'tab-bar
      (setq tab-bar-auto-width-max '((120) 20))
      (setq tab-bar-new-tab-choice 'scratch-buffer)
      (tab-bar-mode +1)
      (setq tab-bar-format (delq 'tab-bar-format-tabs tab-bar-format))
      (add-to-list 'tab-bar-format 'tab-bar-format-tabs-groups t)
      ;; individual window configuration history per tab. Recommend to
      ;; disable `winner-mode' to use commands provided by this mode
      ;; instead.
      (tab-bar-history-mode +1)
      (with-eval-after-load 'ia-tab-bar-modified-consult
        (setopt ia/tab-bar-modified-sanitize-new-tab t)
        (setopt ia/tab-bar-modified-enable-history t)
        (setopt ia/tab-bar-modified-disable-marginalia t)
        (setopt ia/tab-bar-modified-show-extra-states t)
        (ia/tab-bar-modified-consult-mode +1)))))

(ia/feat-chunk ia-setup/ace-window t
  (with-eval-after-load 'ace-window
    (setq aw-dispatch-when-more-than 1
          aw-minibuffer-flag t)))

(provide 'init-layouts)

;;; init-layouts.el ends here
