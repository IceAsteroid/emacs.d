;;;; init-keybinds.el --- All custom keybinds -*- lexical-binding: t -*-

;;; Commentary:
;; 

(require 'init-common)

;;; Code:

(ia/feat-chunk ia-setup/window-management-keymap t
  (with-eval-after-load 'window
    (keymap-set global-map "M-o" 'other-window)
    (keymap-set global-map "M-O" 'ia/other-window-mru)
    (with-eval-after-load 'windmove)))

(ia/feat-chunk ia-setup/buffer-management-keymap t
  (keymap-unset global-map "C-x C-b" 'list-buffers)
  (keymap-set global-map "C-x C-b" 'ibuffer))

(ia/feat-chunk ia-setup/count-lines-keymap t
    (with-eval-after-load 'page
      (with-eval-after-load 'org
        (keymap-unset org-mode-map "C-x l" 'count-lines-page))
      (defvar-keymap ia/line-count-map
        :doc "Keymap for commands that cound lines."
        "L" 'count-lines-page
        "l" 'ia/count-total-lines)
      (keymap-set global-map "C-x l" ia/line-count-map)))

(ia/feat-chunk ia-setup/note-management-keymap t
  (with-eval-after-load 'denote
    (with-eval-after-load 'consult-notes
      (defvar-keymap my/denote-map
        :doc "Keymap for denote commands."
        "c" 'denote-open-or-create
        "d" 'my/denote-switch-directory
        "s" 'denote-silo-open-or-create)
      (defvar-keymap my/consult-notes-map
        :doc "Keymap for consult-notes commands."
        "n" 'consult-notes
        "s" 'consult-notes-search-in-all-notes)
      (defvar-keymap my/meta-n-map
        :doc "Keymap for note management."
        "M-N" my/consult-notes-map
        "M-D" my/denote-map)
      ;; (keymap-unset Info-mode-map "M-n" 'clone-buffer)
      (keymap-set global-map "M-N" my/meta-n-map))))

(ia/feat-chunk ia-setup/org-mode-keymap t
  (with-eval-after-load 'org
    (with-eval-after-load 'consult
      (keymap-set org-mode-map "C-c C-g" 'consult-org-heading))))

(ia/feat-chunk ia-setup/corfu-keymap nil
  (with-eval-after-load 'corfu
    (keymap-unset corfu-map "M-n" 'corfu-next)
    (keymap-unset corfu-map "M-p" 'corfu-previous)
    (keymap-unset corfu-map "RET" 'corfu-insert)))

(ia/feat-chunk ia-setup/embark-keymap t
  ;; unfinished configuration.
  (keymap-set global-map "C-." 'embark-act)
  (keymap-set global-map "C-;" 'embark-dwim))

(ia/feat-chunk ia-setup/man-keymap t
  (keymap-set global-map "C-h M" 'man))

(ia/feat-chunk ia-setup/gt-keymap t
  (with-eval-after-load 'gt
    (keymap-unset global-map "C-h t" 'help-with-tutorial)
    (keymap-set global-map "C-h T" 'help-with-tutorial)
    (keymap-set global-map "C-h t" 'gt-translate)))

(ia/feat-chunk ia-setup/ia/mark-things-at-point-keymap t
  (with-eval-after-load 'init-common
    (keymap-set global-map "C->" 'ia/mark-things-at-point)))

(ia/feat-chunk ia-setup/outline-mode t
  "Set up custom key bindings for outline minor mode using a new prefix."
  ;; Setting this variable doens’t work if `outline' has been loaded
  ;; so the following workaround is needed.
  ;; (setq outline-minor-mode-prefix "") 
  (with-eval-after-load 'outline
    (keymap-set outline-minor-mode-map "C-c" outline-mode-prefix-map)
    (keymap-set outline-mode-prefix-map "C-<tab>" 'outline-cycle)
    (keymap-unset outline-mode-prefix-map "TAB" 'outline-show-children)
    (keymap-set outline-mode-prefix-map "<tab>" 'outline-cycle-buffer)
    (with-eval-after-load 'consult
      (keymap-set outline-mode-prefix-map "C-g" 'consult-outline))))


(provide 'init-keybinds)
;;; init-keybinds.el ends here
