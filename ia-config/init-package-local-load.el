;;; init-package-local-load.el --- Load & configure local packages -*- lexical-binding: t -*-


;;; Commentary:
;;

(require 'init-common)

;;; Code:

(setq ia/local-packages-dir "~/Repos_Mine/Online/Emacs_Packages")

;; `toggle-edit' needs to be revised & compared with its ancestor versions.
(use-package toggle-edit
  :load-path (lambda () (ia/load-dir-recursive "toggle-edit-git" nil t))
  :config
  (toggle-edit-mode +1))

;; `denote-modified' requires a refactor and move regular settings out of it to `init-org.el'.
(use-package denote-modified
  :load-path (lambda () (ia/load-dir-recursive "denote-modified")))

;; `consult-org-modifed' requires a refactor for code quality, but not at a high priority.
(use-package consult-org-modified
  :load-path (lambda () (ia/load-dir-recursive "consult-org-modified"))
  :config
  (setq ia/consult-org-heading-faces-relatve-remap-list
        (append
         ia/consult-org-heading-faces-relatve-remap-list
         '((org-tag :weight normal)
           (org-todo :weight normal)
           (org-done :weight normal)
           (org-priority :weight normal))))
  (dotimes (c 8)
    (add-to-list
     'ia/consult-org-heading-faces-relatve-remap-list
     `(,(intern (format "org-level-%s" (1+ c))) :weight bold))))

(use-package org-subentry-count
  :load-path (lambda () (ia/load-dir-recursive "org-subentry-count"))
  :config
  (setq org-subentry-count-after-change t)
  (defun my/setup-buffer-face-in-org-subentry ()
    (if (or ia/variable-pitch-mode
            (bound-and-true-p mixed-pitch-mode)
            (bound-and-true-p my-mixed-pitch-mode))
        (setq-local org-subentry-count-format " [%s] ")
      (setq-local org-subentry-count-format "[%s]"))
    ;; [Needs fix]It may run twice at the startup for the mode with this
    ;; setup.
    (org-subentry-count-in-headings (point-min) (point-max)))
  ;; All the local hooks & variables will be dropped by
  ;; `kill-all-local-variables' when switching to a new major mode.
  (defun my/setup-in-org-subentry-count-mode ()
    (if org-subentry-count-mode
        (progn
          (my/setup-buffer-face-in-org-subentry)
          (add-hook 'buffer-face-mode-hook 'my/setup-buffer-face-in-org-subentry 100 t)
          (add-hook 'mixed-pitch-mode-hook 'my/setup-buffer-face-in-org-subentry 100 t)
          (add-hook 'my-mixed-pitch-mode-hook 'my/setup-buffer-face-in-org-subentry 100 t))
      (remove-hook 'buffer-face-mode-hook 'my/setup-buffer-face-in-org-subentry t)
      (remove-hook 'mixed-pitch-mode 'my/setup-buffer-face-in-org-subentry t)
      (remove-hook 'my-mixed-pitch-mode-hook 'my/setup-buffer-face-in-org-subentry t)))
  (add-hook 'org-subentry-count-mode-hook 'my/setup-in-org-subentry-count-mode)
  (add-hook 'org-mode-hook 'org-subentry-count-mode))

;;;; Modified themes
;;load the theme directory once without repeat on each user-package section.
(ia/load-dir-recursive "emacs-utils/themes")

(use-package modus-operandi-tinted-dimmer-theme)


(provide 'init-package-local-load)
;;; init-package-local-load.el ends here
