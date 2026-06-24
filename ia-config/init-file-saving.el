;;; init-file-saving.el --- File saving configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(ia/feat-chunk super-save t
  (with-eval-after-load 'super-save
    (setq super-save-delete-trailing-whitespace 'except-current-line)
    (with-eval-after-load 'ia-window-utility
      (add-to-list 'super-save-triggers 'ia/other-window-mru))
    (super-save-mode +1)))

(provide 'init-file-saving)

;;; init-file-saving.el ends here
