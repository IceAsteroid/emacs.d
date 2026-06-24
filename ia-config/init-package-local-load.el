;;; init-package-local-load.el --- Load & configure local packages -*- lexical-binding: t -*-

;;; Commentary:
;;

(require 'ia-core-utility)

;;; Code:

(setq-local ia/local-packages-dir "~/Repos_Mine/Online/Emacs_Packages")

(ia/feat-chunk ia-setup/tedit-4 nil
  (load-file (file-name-concat ia/local-packages-dir "toggle-edit-git/tedit-4.el"))
  (setopt tedit-always-lock-on-switch t)
  (setopt tedit-relock-inhibit-from-deep-minibuffer nil)
  (setopt tedit-toggle-inhibit-if-file-initially-hard-locked t)
  (setopt tedit-soft-lock-toggle-method 'soft-lock)
  (setopt tedit-relock-inhibit-from-buffer-regexps '("\\*Org Select\\*"))
  (setopt tedit-hard-lock-derived-mode-list '(prog-mode text-mode conf-mode))
  (setopt tedit-inhibit-commands '(project-query-replace-regexp))
  (setopt tedit-soft-lock-buffer-regexps '("\\*Async Shell Command\\*"
                                           "treemacs-persist"
                                           "recentf"))
  (setopt tedit-soft-lock-major-mode-list '(special-mode fundamental-mode))
  (setopt tedit-hard-lock-ignore-mode-list '(magit-status-mode magit-log-mode dired-mode))
  (setopt tedit-hard-lock-ignore-buffer-regexps '("^\\*"))
  (setopt tedit-toggle-always-allow-buffer-regexps '("^\\*scratch\\*"))
  (setopt tedit-soft-lock-existing-hard-lock-method 'override)
  (setopt tedit-apply-locks-on-mode-change nil)
  (tedit-mode +1))

(ia/feat-chunk ia-setup/tedit-5 nil
  (use-package tedit
    :load-path (lambda () (ia/load-dir-recursive "toggle-edit-git" nil t))
    :init
    (setopt tedit-always-lock-on-switch t)
    (setopt tedit-relock-inhibit-from-deep-minibuffer nil)
    (setopt tedit-toggle-inhibit-if-file-initially-hard-locked t)
    (setopt tedit-soft-lock-toggle-method 'soft-lock)
    (setopt tedit-relock-inhibit-from-buffer-regexps '("\\*Org Select\\*"))
    (setopt tedit-hard-lock-derived-mode-list '(prog-mode text-mode conf-mode))
    (setopt tedit-inhibit-commands '(project-query-replace-regexp))
    (setopt tedit-soft-lock-buffer-regexps '("\\*Async Shell Command\\*"
                                           "treemacs-persist"
                                           "recentf"))
    (setopt tedit-soft-lock-major-mode-list '(special-mode fundamental-mode))
    (setopt tedit-hard-lock-ignore-mode-list '(magit-status-mode magit-log-mode dired-mode))
    (setopt tedit-hard-lock-ignore-buffer-regexps '("^\\*"))
    (setopt tedit-toggle-always-allow-buffer-regexps '("^\\*scratch\\*"))
    (setopt tedit-soft-lock-existing-hard-lock-method 'override)
    (setopt tedit-clear-hard-lock-before-mode-change t)
    (setopt tedit-apply-locks-on-mode-change t)
    :config
    (tedit-mode +1)))

(ia/feat-chunk ia-setup/tedit-5 t
  (load-file (file-name-concat ia/local-packages-dir "toggle-edit-git/tedit.el"))
  (setopt tedit-always-lock-on-switch t)
  (setopt tedit-relock-inhibit-from-deep-minibuffer nil)
  (setopt tedit-toggle-inhibit-if-file-initially-hard-locked t)
  (setopt tedit-soft-lock-toggle-method 'soft-lock)
  (setopt tedit-relock-inhibit-from-buffer-regexps '("\\*Org Select\\*"))
  (setopt tedit-hard-lock-derived-mode-list '(prog-mode text-mode conf-mode))
  (setopt tedit-inhibit-commands '(project-query-replace-regexp))
  (setopt tedit-soft-lock-buffer-regexps '("\\*Async Shell Command\\*"
                                           "treemacs-persist"
                                           "recentf"))
  (setopt tedit-soft-lock-major-mode-list '(special-mode fundamental-mode))
  (setopt tedit-hard-lock-ignore-mode-list '(magit-status-mode magit-log-mode dired-mode))
  (setopt tedit-hard-lock-ignore-buffer-regexps '("^\\*"))
  (setopt tedit-toggle-always-allow-buffer-regexps '("^\\*scratch\\*"))
  (setopt tedit-soft-lock-existing-hard-lock-method 'override)
  (setopt tedit-clear-hard-lock-before-mode-change t)
  (setopt tedit-apply-locks-on-mode-change t)
  (tedit-mode +1))


(ia/feat-chunk ia-setup/denote-modified t
  ;; `denote-modified' requires a refactor and move regular settings out of it to `init-org.el'.
  (use-package denote-modified
    :load-path (lambda () (ia/load-dir-recursive "denote-modified"))))

(ia/feat-chunk ia-setup/consult-org-modified t
  ;; `consult-org-modifed' requires a refactor for code quality, but not at a high priority.
  (use-package consult-org-modified
    :load-path (lambda () (ia/load-dir-recursive "consult-org-modified"))
    :config
    (setq ia/consult-org-heading-remap-default-face
          `(:family "Sarasa Fixed K" :weight normal :height 0.9))
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
       `(,(intern (format "org-level-%s" (1+ c))) :weight bold)))))

(ia/feat-chunk ia-setup/org-subentry-count nil
  (use-package org-subentry-count
    :load-path (lambda () (ia/load-dir-recursive "org-subentry-count"))
    :config
    (setq org-subentry-count-after-change t)
    (defun my/setup-buffer-face-in-org-subentry ()
      (if (or (ia/variable-pitch-p)
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
    (add-hook 'org-mode-hook 'org-subentry-count-mode)))


(ia/feat-chunk ia-setup/org-subentry-count nil
  (load-file (file-name-concat ia/local-packages-dir "org-subentry-count/org-subentry-count-new-2.el"))
  ;; (setopt org-subentry-count-position 'after-string)
  (add-hook 'org-mode-hook 'org-subentry-count-mode))

(ia/feat-chunk ia-setup/org-subentry-count nil
  (load-file (file-name-concat ia/local-packages-dir "org-subentry-count/org-subentry-count-new-2-1.el"))
  (setopt org-subentry-count-position 'after-string)
  (setopt org-subentry-count-format "[%s] ")
  (add-hook 'org-mode-hook 'org-subentry-count-mode))

(ia/feat-chunk ia-setup/org-subentry-count t
  (load-file (file-name-concat ia/local-packages-dir "org-subentry-count-mode-git/org-subentry-count.el"))
  (setopt org-subentry-count-position 'display)
  (setopt org-subentry-count-format "[%s]")
  (add-hook 'org-mode-hook 'org-subentry-count-mode))


(provide 'init-package-local-load)
;;; init-package-local-load.el ends here
