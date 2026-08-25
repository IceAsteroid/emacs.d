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

;; Load emacs-utils repository
(add-to-list 'load-path "~/Repos_Mine/Online/Emacs_Packages/emacs-utils" t)
(setq ia/emacs-utils-sub-dirs '("core" "layout" "appearance" "buffer"
                                "completion" "org" "workaround"
                                "info-inbox" "doc-lookup"))
;; entry point that loads sub dirs.
(require 'emacs-utils)
(ia/emacs-utils-load-sub-dirs)

;; Load local configurations that are in .emacs.d
(add-to-list 'load-path "~/.emacs.d/ia-config/" t)


(with-eval-after-load 'init-package-install
  (require 'ia-fix-pgtk-childframe-lag-58556)
  (require 'ia-fix-theme-custom-theme-set-faces-68880)
  (require 'ia-fix-man-osc8-hyperlink-81240)
  (require 'ia-fix-gt-treesit-hang-82)
  (require 'ia-fix-window-state-put-73627)
  (require 'ia-fix-org-block-regexp-overflow)
  (require 'ia-modus-operandi-tinted-dimmer-theme)
  (require 'ia-face-utility)
  (require 'ia-persist-set-faces)
  (require 'ia-tab-bar-modified-consult)
  (require 'ia-popper-modified)
  (require 'ia-window-utility)
  (require 'ia-window-prefix-pivot)
  (require 'ia-buffer-utility)
  (require 'ia-breadcrumb-modified)
  (require 'ia-vundo-utility)
  (require 'ia-bash-ts-mode-modified)
  (require 'ia-combobulate-bash)
  (require 'ia-cape-capf-sort-utility)
  (require 'ia-org-utility)
  (require 'ia-org-item-toggle)
  (require 'ia-org-indent-modified)
  (require 'ia-consult-org-preselect-nearest)
  (require 'ia-elfeed-modified)
  (require 'ia-help-modified)
  (require 'ia-pdf-tools-modified))

(require 'init-basic)
(require 'init-package-install)
(auto-compile-on-load-mode +1)
(auto-compile-on-save-mode +1)
(require 'init-appearance)
(require 'init-package-local-load)
(require 'init-performance-tweak)
(require 'init-buffer)
(require 'init-layouts)
(require 'init-minibuffer)
(require 'init-completion-at-point)
(require 'init-contextual)
(require 'init-programming)
(require 'init-vcs)
(require 'init-org)
(require 'init-file-saving)
(require 'init-linguistics)
(require 'init-info-inbox)
(require 'init-doc-lookup)
(require 'init-keybinds)

;; Trust management
(add-to-list 'trusted-content "~/Repos_Mine/Online/emacs.d/")
(trust-manager-mode +1)

;; Load configs not tracked by version control.
(add-to-list 'load-path "~/.emacs.d/ia-config-novcs" t)
(require 'init-novcs-appearance)
(require 'init-novcs-org)
(require 'init-novcs-linguistics)
(require 'init-novcs-info-inbox)
(require 'init-novcs-security)

(ia/feat-chunk ia-setup/completion-category t
  (with-eval-after-load 'orderless
    (setq completion-styles '(orderless basic))
    ;; disable emacs' rigid defaults so orderless can apply globally.
    (setq completion-category-defaults nil)
    ;; protect categories that strictly require prefix/partial matching (like files)
    (setq completion-category-overrides '((file (styles partial-completion))))
    ;; partial-completion behaves like substring starting at emacs 31
    (when (>= emacs-major-version 31)
      (setq completion-pcm-leading-wildcard t))
    (with-eval-after-load 'org-refile
      ;; Must set nil to display full paths, otherwise it won't work well with orderless
      (setq org-outline-path-complete-in-steps nil))))

;;; init.el ends here
