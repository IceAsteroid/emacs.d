;;; init-contextual.el --- Contextual hinting & action configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;

(ia/feat-chunk ia-setup/embark t
  (with-eval-after-load 'embark
    (setq embark-indicators (delq 'embark-mixed-indicator embark-indicators))
    (add-to-list 'embark-indicators 'embark-minimal-indicator)
    ;; Change the function that shows proceeding keybinds after a prefix key is hit.
    (setq prefix-help-command 'embark-prefix-help-command)))

(ia/feat-chunk ia-setup/consult t
  (with-eval-after-load 'consult
    (setopt consult-ripgrep-args
            ;; use `ia/ensure-substring' to prevent duplication when re-evaled.
            (ia/ensure-substring consult-ripgrep-args "--hidden --follow" " "))
    (setopt consult-fontify-max-size (* 1048576 2))
    ;; buffers larger than the set size are previewed partially. So
    ;; set it larger to preview & jump for all contents of large
    ;; buffers.  If partially previewed, consult cannot properly
    ;; locate to a line in the previewed window.
    (setopt consult-preview-partial-size (* 1048576 2))
    ;; The number is the delay for preview
    (setopt consult-preview-key (list :debounce 0.2 'any))

    (with-eval-after-load 'consult-imenu
     (add-to-list 'consult-imenu-config
                  '(sh-mode :toplevel "Function"
                            :toplevel "Variable"
                            :types ((?f "Functions" font-lock-function-name-face)
                                   (?v "Variables" font-lock-variable-name-face)
                                   (?t "Type"     font-lock-type-face)))))))

(provide 'init-contextual)

;;; init-contextual.el ends here
