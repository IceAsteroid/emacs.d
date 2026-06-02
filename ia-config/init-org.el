;;;; init-org.el --- Org-mode related configuration.  -*- lexical-binding: t; -*-


;;; Commentary:
;; 

(require 'init-common)

;;; Code:

(ia/feat-chunk ia-setup/denote t
  ;; Extra config is in `denote-modified'.
  (with-eval-after-load 'denote
    (setq denote-history-completion-in-prompts t)
    (setq denote-infer-keywords t)
    (setq denote-file-type 'org)
    (with-eval-after-load 'denote-silo
      (with-eval-after-load 'org
        (setq denote-silo-directories
              (flatten-tree (list "~/OrgWiki/SiloDiary_ZH"
                                  org-agenda-files)))))
    (with-eval-after-load 'consult-notes
      (consult-notes-denote-mode 1))))

(ia/feat-chunk ia-setup/consult-org t
  (with-eval-after-load 'consult-org
    (defun ia-advice/consult-org-heading-after (&rest _)
      "Fold all sublevel entries execpt the selected entry and its parent entires."
      (org-fold-hide-sublevels 1)
      (org-fold-show-entry)
      (org-fold-show-children)
      (org-fold-show-siblings))
    (advice-add 'consult-org-heading :after 'ia-advice/consult-org-heading-after)))

(ia/feat-chunk ia-setup/org-mode t
  (with-eval-after-load 'org
    (setq org-startup-truncated nil)
    (setq org-startup-folded 'fold)
    (setq org-hide-block-startup t)))

(provide 'init-org)
;;; init-org.el ends here
