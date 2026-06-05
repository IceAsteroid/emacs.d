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
    (corfu-echo-mode +1)
    (corfu-history-mode +1)
    (global-corfu-mode +1)))

(setq eldoc-documentation-strategy #'eldoc-documentation-compose)


(provide 'init-completion-at-point)

;;; init-completion-at-point.el ends here
