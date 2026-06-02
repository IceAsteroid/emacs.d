;;; init-contextual.el --- Contextual hinting & action configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; 

(ia/feat-chunk ia-setup/embark t
  (with-eval-after-load 'embark
    (setq embark-indicators (delq 'embark-mixed-indicator embark-indicators))
    (add-to-list 'embark-indicators 'embark-minimal-indicator)
    ;; Change the function that shows proceeding keybinds after a prefix key is hit.
    (setq prefix-help-command 'embark-prefix-help-command)))

(provide 'init-contextual)

;;; init-contextual.el ends here
