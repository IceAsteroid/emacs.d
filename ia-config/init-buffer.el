;;; init-buffer.el --- Buffer & Editing Configuration

;;; Commentary:
;; 

;;; Code:

(ia/feat-chunk ia-setup/outline-minor-mode-setup t
  (with-eval-after-load 'outline
    (setq outline-minor-mode-highlight t))
  ;; Enable outline minor mode in emacs-lisp-mode buffers.
  (add-hook 'emacs-lisp-mode-hook 'outline-minor-mode))

(setq-default show-trailing-whitespace t)

(provide 'init-buffer)

;;; init-buffer.el ends here
