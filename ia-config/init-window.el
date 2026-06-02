;;; init-window.el --- Window Management Setup  -*- lexical-binding: t; -*-

(require 'init-common)

(ia/feat-chunk ia-setup/window-managgement t
  (winner-mode 1)
  (windmove-mode 1))

(provide 'init-window)

;;; init-window.el ends here
