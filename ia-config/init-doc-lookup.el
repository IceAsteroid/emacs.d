;;; init-doc-lookup.el --- Emacs documentation setup -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:

(setopt ia/help-modified-customizable-status t)
(ia/help-modified-mode +1)

(setopt Man-notify-method 'thrifty)

(ia/feat-chunk pdf-tools t
  (with-eval-after-load 'pdf-tools
    (setq pdf-view-use-imagemagick t)
    (setq pdf-cache-image-limit (* 5 1024 1024))
    (defun ia-hook/pdf-view-mode-misc ()
      (pdf-view-themed-minor-mode 1)
      (pdf-view-auto-slice-minor-mode 1) ;Causes scaling to not work in new releases, the issue has been posted in the official repo by me.
      (pdf-view-fit-page-to-window)
      (pdf-outline-imenu-enable))
    (add-hook 'pdf-view-mode-hook 'ia-hook/pdf-view-mode-misc)
    (with-eval-after-load 'ia-pdf-tools-modified
      (ia/pdf-tools-modified-mode +1))
    ;; Enable pdf-tools for pdf files.
    (pdf-tools-install-noverify)))


(provide 'init-doc-lookup)

;;; init-doc-lookup.el ends here
