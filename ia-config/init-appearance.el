;;; init-appearance.el --- Face & theme configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(require 'ia-core-utility)

;;; Code:

;; Enable the Bug#68880 workaround for `custom-theme-set-faces' on the
;; affected Emacs versions (28 < version < 31).  If the current Emacs
;; version is not one where the bug exists (e.g. >= 31.1, where the bug
;; is fixed upstream), the mode does not take effect.
(with-eval-after-load 'ia-fix-theme-custom-theme-set-faces-68880
  (ia-fix/theme-custom-theme-set-faces-68880-mode 1))

(defun ia-advice/disable-all-themes (&rest _)
  "Reset all faces of enabled themes before loading a new theme."
  (mapcar 'disable-theme custom-enabled-themes))
(advice-add 'load-theme :before 'ia-advice/disable-all-themes)

(ia/feat-chunk ia-setup/custom-theme-user-faces t
  "Using `custom-theme-set-faces' for either 'user or a theme to set
partially attributes of a face overrides all."
  (custom-theme-set-faces
   'user
   '(default ((t (:family "Sarasa Fixed K" :height 120))))
   '(variable-pitch ((t (:family "Sarasa Fixed K" :height 1.0 :weight normal))))
   '(fixed-pitch ((t (:family "Sarasa Fixed K" :height 1.0))))
   '(fixed-pitch-serif ((t (:family "Sarasa Fixed K" :height 1.0 :weight bold))))))

(ia/feat-chunk ia-setup/tango-theme t
  (with-eval-after-load 'tango-theme
    (custom-theme-set-faces
     'tango
     '(diff-hl-change ((t (:background "#c0b200"))))    ; color from modus-operandi.
     '(diff-hl-delete ((t (:background "#d84a4f"))))    ; color form modus-operandi.
     '(diff-hl-insert ((t (:background "#6cc06c"))))))) ; color form modus-operandi.

(ia/feat-chunk ia-setup/load-faces-after-theme t
  "Using the `ia/theme-set-faces' macro to load custom attributes will not
override other attributes of a face defined by the current theme."

  (ia/feat-chunk ia-setup/ace-window-faces t
    (with-eval-after-load 'ace-window
      (ia/theme-set-faces
        '(aw-leading-char-face
          :height 400))))

  (ia/feat-chunk ia-setup/diff-hl-margin-faces t
    (with-eval-after-load 'diff-hl-margin
      (ia/theme-set-faces
        ;; Consistent margin foreground, it by default follows the first
        ;; char's face per line since foreground specs are unset.
        '(diff-hl-margin-change
          :foreground (face-attribute 'default :foreground) :weight 'bold)
        '(diff-hl-margin-delete
          :foreground (face-attribute 'default :foreground) :weight 'bold)
        '(diff-hl-margin-insert
          :foreground (face-attribute 'default :foreground) :weight 'bold))))

  (ia/feat-chunk ia-setup/shr-faces t
    (with-eval-after-load 'shr
      (ia/theme-set-faces
        ;; elfeed-show-mode uses this face to display text.  Since the
        ;; nice fixed font "Sarasa Fixed K" is also set as
        ;; `variable-pitch's font we don't want its font bigger as the
        ;; face inherits from `variable-pitch-text'.
        '(shr-text :height 'reset))))

  (ia/feat-chunk ia-setup/org-faces t
    (with-eval-after-load 'org-indent
      (ia/theme-set-faces
        ;; some themes set `org-indent' to inherit `fixed-pitch', if
        ;; fixed-pitch is set to a different height then `default'
        ;; where the normal text's face is, the width will differ.
        ;; One premise to achieve same width: the default and
        ;; fixed-pitch must be the same monospace font.  Setting a
        ;; decimal height only multiply it with the inherited face, we
        ;; need 'reset here to set back to default.
        '(org-indent :height 'reset))))
  )

(provide 'init-appearance)

;;; init-appearance.el ends here
