;;; init-window.el --- Window Management Setup  -*- lexical-binding: t; -*-

(require 'init-common)

(ia/feat-chunk ia-setup/window-managgement t
  (winner-mode +1)
  (windmove-mode +1)
  (global-tab-line-mode +1))

(ia/feat-chunk ia-setup/ace-window t
  (with-eval-after-load 'ace-window
    (setq aw-dispatch-when-more-than 1
          aw-minibuffer-flag t)))

(provide 'init-window)

;;; init-window.el ends here
