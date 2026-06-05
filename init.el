;;;; init.el --- Emacs configuration file -*- lexical-binding: t -*-

;;; Commentary:
;; idea: Top to down configuration structure for better bisecting bugs when debugging.

;;; Code:

(add-to-list 'load-path "~/.emacs.d/ia-config/" t)
(require 'init-common)
(require 'init-basic)
(require 'init-appearance)
(require 'init-package-install)
(require 'init-package-local-load)
(require 'init-performance-tweak)
(require 'init-buffer)
(require 'init-window)
(require 'init-minibuffer)
(require 'init-completion-at-point)
(require 'init-contextual)
(require 'init-programming)
(require 'init-vcs)
(require 'init-org)
(require 'init-linguistics)
(require 'init-keybinds)


(with-eval-after-load 'orderless
    (setq completion-styles '(orderless basic))
    (with-eval-after-load 'org-refile
      ;; Must set nil to display full paths, otherwise it won't work well with orderless
      (setq org-outline-path-complete-in-steps nil)))

(load-theme 'tango)

(setq-default indent-tabs-mode nil)
(setq standard-indent 4)
(setq-default tab-width 8)


;;; init.el ends here
