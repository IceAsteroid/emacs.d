;;; init-vcs.el --- Version Control Configuration

;;; Commentary:
;; 

(ia/feat-chunk ia-setup/magit t
  (with-eval-after-load 'magit
    (magit-wip-mode +1)))

(ia/feat-chunk ia-setup/diff-hl t
  (with-eval-after-load 'diff-hl
    (global-diff-hl-mode +1)
    (diff-hl-margin-mode +1)))


(provide 'init-vcs)

;;; init-vcs.el ends here
