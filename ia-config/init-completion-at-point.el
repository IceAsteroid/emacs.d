;;; init-completion-at-point.el --- completion-at-point configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(require 'ia-core-utility)

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

    (with-eval-after-load 'cape
      (defun ia-hook/emacs-lisp-mode-capf ()
        (setq-local completion-at-point-functions
                    (list
                     ;; `cape-elisp-symbol' can not handle to jump
                     ;; to next backend `cape-elisp-symbol' if the
                     ;; backends not wrapped in `cape-capf-choose'
                     (cape-capf-choose
                      'elisp-completion-at-point
                      'cape-file
                      'cape-dabbrev))))
      (add-hook 'emacs-lisp-mode-hook #'ia-hook/emacs-lisp-mode-capf)
      
      (defun ia-hook/sh-mode-capf ()
        (setq-local completion-at-point-functions
                    (list
                     (cape-capf-choose
                      'sh-completion-at-point-function
                      'cape-file
                      'cape-dabbrev))))
      (add-hook 'sh-mode-hook #'ia-hook/sh-mode-capf)

      (ia/feat-chunk eglot-mode-capf t
        (with-eval-after-load 'eglot
          ;; If eglot kicks in for a buffer, override buffer's
          ;; completion functions.
          ;;
          ;; Try to generalize for different buffer modes and lsp
          ;; servers.
          (defun ia-hook/eglot-mode-capf ()
            (setq-local completion-at-point-functions
                        (list
                         (cape-capf-choose
                          'eglot-completion-at-point
                          'cape-file
                          'cape-dabbrev))))
          (add-hook 'eglot-managed-mode-hook #'ia-hook/eglot-mode-capf)))
      )))

(ia/feat-chunk ia-setup/kind-icon t
  (with-eval-after-load 'kind-icon
    (setq kind-icon-use-icons nil)
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)))

(setq eldoc-documentation-strategy #'eldoc-documentation-compose)


(provide 'init-completion-at-point)

;;; init-completion-at-point.el ends here
