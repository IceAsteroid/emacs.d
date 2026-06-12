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
  (setq pop-up-windows nil))

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
