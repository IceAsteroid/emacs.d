;;; init-org.el --- Org-mode related configuration.  -*- lexical-binding: t; -*-


;;; Commentary:
;;

(require 'ia-core-utility)

;;; Code:

(ia/feat-chunk ia-setup/denote t
  ;; Extra config is in `denote-modified'.
  (with-eval-after-load 'denote
    (setq denote-history-completion-in-prompts t)
    (setq denote-infer-keywords t)
    (setq denote-file-type 'org)
    (with-eval-after-load 'consult-notes
      (consult-notes-denote-mode 1))))

(ia/feat-chunk ia-setup/consult-org t
  (with-eval-after-load 'consult-org
    (ia/feat-chunk ia-setup/consult-org-fold-except-selected t
      (defun ia-advice/consult-org-fold-except-selected (&rest _)
        "Fold all sub-level entries except the selected entry and its parent entries.

The goals:
1. Fold all first-level headings and selectively show its subheadings
according to the following rules for the selected heading.

2. Show the selected heading's siblings of the direct parent heading but
keep their subheadings and contents folded.

3. Show headings that are levels higher than the selected heading of the
first-level parent heading, but keep their subheadings and contents folded."
        (when (derived-mode-p 'org-mode)
          (org-fold-hide-sublevels 1)
          ;; Save point position at the selected heading.
          (save-excursion
            ;; Show children for the selected heading, and its direct
            ;; parent heading, up to its first level parent heading.
            ;; This also achieve to show the sibling headings of the
            ;; selected within the direct parent heading without an
            ;; additional `org-fold-show-siblings' at the selected.
            (while (progn (org-fold-show-children)
                          (org-up-heading-safe))))
          (org-fold-show-entry)))
      (advice-add #'consult-org-heading :after #'ia-advice/consult-org-fold-except-selected))

    (ia/feat-chunk ia-setup/consult-org-preselect-nearest t
      (with-eval-after-load 'ia-consult-org-preselect-nearest
        (ia/consult-org-preselect-nearest-mode +1)))
    ))

(ia/feat-chunk ia-setup/org-mode t
  (with-eval-after-load 'org
    (setopt org-startup-truncated nil)
    (setopt org-startup-folded 'fold)
    (setopt org-hide-block-startup t)
    (setopt org-hide-emphasis-markers t)
    (setopt org-ellipsis "…")
    (setopt org-hierarchical-todo-statistics nil)
    (setopt org-pretty-entities t)

    (ia/feat-chunk ia-setup/org-agenda t
      ;; skip unavailable dirs or files instead of asking to remove.
      (setopt org-agenda-skip-unavailable-files t))

    (ia/feat-chunk ia-setup/org-indent t
      (setopt org-startup-indented t)
      (with-eval-after-load 'org-superstar
        (defun ia-hook/org-indent-mode-superstar ()
          (if org-indent-mode
              (setq-local org-superstar-remove-leading-stars nil)
            ;; restore back to the default global value of the variable.
            (setq-local org-superstar-remove-leading-stars (default-value 'org-superstar-remove-leading-stars)))
          (org-superstar-restart))
        (add-hook 'org-indent-mode-hook 'ia-hook/org-indent-mode-superstar))
      (with-eval-after-load 'ia-org-indent-modified
          (ia/org-indent-modified-mode +1)))
    ))

(ia/feat-chunk ia-setup/org-superstar t
  (with-eval-after-load 'org-superstar
    (setopt org-superstar-remove-leading-stars t)
    ;; Full-width A B C D..
    (setopt org-superstar-headline-bullets-list
          '(65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84))
    (setopt org-superstar-item-bullet-alist '((?* . ?◩) (?+ . ?■) (?- . ?◧)))
    (add-hook 'org-mode-hook 'org-superstar-mode)))

(ia/feat-chunk ia-setup/org-phscroll t
  (setq org-startup-truncated nil)
  (with-eval-after-load 'org
    (with-eval-after-load 'phscroll
      (require 'org-phscroll))))

(ia/feat-chunk ia-setup/corg t
  (with-eval-after-load 'corg
    (add-hook 'org-mode-hook 'corg-setup)))

(provide 'init-org)
;;; init-org.el ends here
