;;; init-vcs.el --- Version Control Configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; 

;;; Code:

(ia/feat-chunk ia-setup/magit t
  (with-eval-after-load 'magit
    (magit-wip-mode +1)))

(ia/feat-chunk ia-setup/diff-hl t
  (with-eval-after-load 'diff-hl
    (setq diff-hl-margin-symbols-alist
          '((insert . "+") (delete . "-") (change . "∗")
            (unknown . "?") (ignored . "#") (reference . "r")))
    (global-diff-hl-mode +1)
    (diff-hl-margin-mode +1)))


(provide 'init-vcs)

;;; init-vcs.el ends here
