;;;; init.el --- Emacs configuration file -*- lexical-binding: t -*-

;;; Commentary
;; idea: Top to down configuration structure for better bisecting bugs when debugging.

(add-to-list 'load-path "~/.emacs.d/ia-config/" t)
(require 'init-common)
(require 'init-basic)
(require 'init-appearance)
(require 'init-package-install)
(require 'init-package-local-load)
(require 'init-window)
(require 'init-completion-at-point)
(require 'init-contextual)
(require 'init-programming)
(require 'init-vcs)
(require 'init-org)
(require 'init-linguistics)
(require 'init-keybinds)


(with-eval-after-load 'vertico
  (setq vertico-count 20)
  (setq vertico-scroll-margin (/ vertico-count 2))  ;keep current canddiate at middle.
  (vertico-mode +1))
(with-eval-after-load 'marginalia
  (marginalia-mode +1))

(with-eval-after-load 'orderless
    (setq completion-styles '(orderless basic))
    (with-eval-after-load 'org-refile
      ;; Must set nil to display full paths, otherwise it won't work well with orderless
      (setq org-outline-path-complete-in-steps nil)))

(load-theme 'tango)

(setq-default indent-tabs-mode nil)
(setq standard-indent 4)
(setq-default tab-width 8)


(ia/feat-chunk ia-setup/outline-minor-mode-setup t
  "Set up custom key bindings for outline minor mode using a new prefix."
  ;; Setting this variable doens’t work if outline has been loaded, so the
  ;; following workaround is needed.
  ;; (setq outline-minor-mode-prefix "")
  (with-eval-after-load 'outline
    (setq outline-minor-mode-highlight t)
    ;; Remove all the bindings that include `outline-minor-mode-prefix' as
    ;; part of their key sequences.nn
    ;; `keymap-set' cannot interpret modifer keys like "" properly, so use
    ;; `define-key' instead.
    (define-key outline-minor-mode-map outline-minor-mode-prefix nil)
    (keymap-unset outline-mode-prefix-map "TAB" 'outline-show-children)
    (keymap-set outline-minor-mode-map "C-c" outline-mode-prefix-map)
    (keymap-set outline-minor-mode-map "C-c C-<tab>" 'outline-cycle)
    (keymap-set outline-minor-mode-map "C-c <tab>" 'outline-cycle-buffer)
    )
  ;; Enable outline minor mode in emacs-lisp-mode buffers.
  (add-hook 'emacs-lisp-mode-hook 'outline-minor-mode)
  (add-hook 'outline-minor-mode-hook
            (lambda () (keymap-local-set "C-c C-g" #'consult-outline))))

