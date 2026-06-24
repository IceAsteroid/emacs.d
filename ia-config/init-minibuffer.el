;;; init-minibuffer.el --- Minibuffer Configuration

;;; Commentary:
;; 

;;; Code:

(ia/feat-chunk ia-setup/vertico t
  (with-eval-after-load 'vertico
    (setopt vertico-count 20)
    (setopt vertico-scroll-margin (/ vertico-count 2))  ;keep current canddiate at middle.
    (vertico-mode +1)))

(ia/feat-chunk ia-setup/marginalia t
  (with-eval-after-load 'marginalia
    (marginalia-mode +1)))

(provide 'init-minibuffer)

;;; init-minibuffer.el ends here
