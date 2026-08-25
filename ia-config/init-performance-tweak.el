;;; init-performance-tweak.el --- Emacs Performance Tweak  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(with-eval-after-load 'gcmh
  (setq gcmh-idle-delay 'auto)
  (gcmh-mode 1))

(setq redisplay-skip-fontification-on-input t)

(provide 'init-performance-tweak)

;;; init-performance-tweak.el ends here
