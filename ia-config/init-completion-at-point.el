;;; init-completion-at-point.el --- completion-at-point configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; 

(require 'init-common)

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
      ;; 1. Tell Corfu to step aside and not re-sort the final combined list
      (setq-local corfu-sort-function nil)

      ;; Note: Grouping backends with `cape-capf-super' in
      ;; `ia-wrap-with-presort' requires the correct one to be first
      ;; specified that fits the buffer type, so it obeys the correct
      ;; boundary rules, in programming modes, the symbol capf back
      ;; end should be first, otherwise the compiletion will
      ;; expectedly auto fill, if a word back end is first.

      ;; 2. Build the super-capf out of pre-sorted data streams
      (setq-local completion-at-point-functions
                  (list (cape-capf-super
                         (ia-wrap-with-presort #'elisp-completion-at-point
                                               #'ia--sort-length-alpha)
                         (ia-wrap-with-presort #'cape-dabbrev
                                               #'ia--sort-length-alpha)))))
    (add-hook 'emacs-lisp-mode-hook #'ia-hook/capf-emacs-lisp-mode)))

(ia/feat-chunk ia-setup/kind-icon t
  (with-eval-after-load 'kind-icon
    (setq kind-icon-use-icons nil)
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)))

(setq eldoc-documentation-strategy #'eldoc-documentation-compose)


(provide 'init-completion-at-point)

;;; init-completion-at-point.el ends here
