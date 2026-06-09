;;;; init.el --- Emacs configuration file -*- lexical-binding: t -*-

;;; Commentary:
;; idea: Top to down configuration structure for better bisecting bugs when debugging.

;;; Todo
;; Rethink and reconfigure window management, previously heavily using
;; the modified `popper-mode' and `consult-buffer' with preview turned
;; on, I'm thinking if this is a good idea or not
;; References:
;; https://karthinks.com/software/emacs-window-management-almanac/

;;; Code:

(add-to-list 'load-path "~/.emacs.d/ia-config/" t)
(require 'init-common)
(require 'init-workaround)
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

;; Load configs not tracked by version control.
(add-to-list 'load-path "~/.emacs.d/ia-config-novcs" t)
(require 'init-novcs-appearance)

(with-eval-after-load 'orderless
    (setq completion-styles '(orderless basic))
    (with-eval-after-load 'org-refile
      ;; Must set nil to display full paths, otherwise it won't work well with orderless
      (setq org-outline-path-complete-in-steps nil)))

(setq-default indent-tabs-mode nil)
(setq standard-indent 4)
(setq-default tab-width 8)


;;; init.el ends here
