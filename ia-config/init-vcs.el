;;; init-vcs.el --- Version Control Configuration

;;; Commentary:
;; 

(ia/feat-chunk ia-setup/magit t
  (with-eval-after-load 'magit
    (magit-wip-mode +1)))

(provide 'init-vcs)

;;; init-vcs.el ends here
