;;; init-appearance.el --- Face & theme configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; 

(require 'init-common)

;;; Code:

(custom-theme-set-faces
 'user
 '(default ((t (:family "Sarasa Fixed K" :height 120))))
 '(variable-pitch ((t (:family "Noto Sans SemiCondensed" :height 1.0 :weight normal))))
 '(fixed-pitch ((t (:family "Sarasa Fixed K" :height 0.82))))
 '(fixed-pitch-serif ((t (:family "Sarasa Fixed K" :height 1.0 :weight bold)))))


(provide 'init-appearance)

;;; init-appearance.el ends here
