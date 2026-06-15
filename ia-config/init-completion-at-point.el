;;; init-completion-at-point.el --- completion-at-point configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(require 'init-common)

;;; Code:

(ia/feat-chunk ia-setup/corfu t
  (with-eval-after-load 'corfu
    (setq tab-always-indent 'complete)
    (setq corfu-popupinfo-delay '(1.2 . 0.2))
    (setq corfu-echo-delay '(1.2 . 0.2))
    (setq corfu-auto-prefix 3)
    (setq corfu-auto-delay 0.1)
    (setq corfu-auto nil)
    ;; (corfu-popupinfo-mode +1)
    (add-to-list 'completion-at-point-functions 'cape-dabbrev 'append)
    (corfu-echo-mode +1)
    (corfu-history-mode +1)
    (global-corfu-mode +1)

    (defun ia-hook/capf-emacs-lisp-mode ()
      (setq-local completion-at-point-functions
                  (list (cape-capf-inside-string 'cape-file)
                        ;; `cape-elisp-symbol' can not handle to jump
                        ;; to next backend `cape-elisp-symbol' if the
                        ;; backends not wrapped in `cape-capf-choose'
                        (cape-capf-super
                         'elisp-completion-at-point
                         'cape-dabbrev))))
    (add-hook 'emacs-lisp-mode-hook #'ia-hook/capf-emacs-lisp-mode)))

(ia/feat-chunk ia-setup/kind-icon t
  (with-eval-after-load 'kind-icon
    (setq kind-icon-use-icons nil)
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)))

(setq eldoc-documentation-strategy #'eldoc-documentation-compose)


(provide 'init-completion-at-point)

;;; init-completion-at-point.el ends here
