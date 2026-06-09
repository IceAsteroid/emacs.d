;;; init-appearance.el --- Face & theme configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(require 'init-common)

;;; Code:

(defun ia-advice/disable-all-themes (&rest _)
  (mapcar 'disable-theme custom-enabled-themes))
(advice-add 'load-theme :before 'ia-advice/disable-all-themes)

(ia/feat-chunk ia-setup/custom-theme-user-faces t
  "Setting partially attributes of a face overrides all."
  (custom-theme-set-faces
   'user
   '(default ((t (:family "Sarasa Fixed K" :height 120))))
   '(variable-pitch ((t (:family "Noto Sans SemiCondensed" :height 1.0 :weight normal))))
   '(fixed-pitch ((t (:family "Sarasa Fixed K" :height 0.82))))
   '(fixed-pitch-serif ((t (:family "Sarasa Fixed K" :height 1.0 :weight bold))))))

(ia/feat-chunk ia-setup/tango-theme t
 (with-eval-after-load 'tango-theme
  (ia-fix/custom-theme-set-faces
   'tango
   '(diff-hl-change ((t (:background "#c0b200"))))    ; color from modus-operandi.
   '(diff-hl-delete ((t (:background "#d84a4f"))))    ; color form modus-operandi.
   '(diff-hl-insert ((t (:background "#6cc06c"))))))) ; color form modus-operandi.


(provide 'init-appearance)

;;; init-appearance.el ends here
