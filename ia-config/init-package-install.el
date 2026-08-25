;;; init-package-install.el --- Install & Initialize packages -*- lexical-binding: t -*-

;;; Commentary:
;;

(require 'package)
(require 'package-vc) ;required to load 3rd party packages' sources
(require 'ia-core-utility)

;;; Code:

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize nil)

;;;; Third-party packages in local host
(ia/feat-chunk ia/local-package-vc-install t
  (setq-local ia/local-packages-dir "~/Repos_Third_Party/Emacs_Packages")
  (ia/package-vc-install-local "pdf-tools")
  (ia/package-vc-install-local "combobulate")
  (ia/package-vc-install-local "phscroll")
  (with-eval-after-load 'zig-mode
    (ia/package-vc-install-local "ob-zig")))

;;;; Performance
(ia/package-install 'gcmh)

;;;; Themes
(add-to-list 'package-pinned-packages '(ef-themes . "gnu"))
(ia/package-install 'ef-themes)

;;;; Completion
(ia/package-install 'vertico)
(ia/package-install 'marginalia)
(ia/package-install 'orderless)
(ia/package-install 'consult)

;;;; Window Management
(ia/package-install 'popper)
;; (ia/package-install 'shackle)
(ia/package-install 'ace-window)

;;;; Programming
(ia/package-install 'corfu)
(ia/package-install 'cape)
(ia/package-install 'kind-icon)
(ia/package-install 'treesit-auto)
(ia/package-install 'zig-mode)
(ia/package-install 'zig-ts-mode)

;;;; Elisp
(ia/package-install 'buttercup)

;;;; Contextual hinting
(ia/package-install 'embark)
(ia/package-install 'embark-consult)

;;;; Git
(ia/package-install 'magit)
(ia/package-install 'forge)
(ia/package-install 'diff-hl)

;;;; Org-mode
(ia/package-install 'denote)
(ia/package-install 'denote-silo)
(ia/package-install 'consult-notes)
(ia/package-install 'org-superstar)
(ia/package-install 'plantuml-mode)
(ia/package-install 'corg)
(ia/package-install 'd2-mode)
;; (ia/package-install 'ob-d2)

;;;; Linguistics & Translation
(ia/package-install 'gt)
(ia/package-install 'jinx)

;;;; Info aggregation
(ia/package-install 'elfeed)
(ia/package-install 'elfeed-tube)
(ia/package-install 'elfeed-tube-mpv)

;;;; Documentation enhancement
(ia/package-install 'helpful)

;;;; AI
(ia/package-install 'eca)

;;; File saving
(ia/package-install 'super-save)

;;;; Misc
(ia/package-install 'dirvish)
(ia/package-install 'treemacs)
(ia/package-install 'trust-manager)
(ia/package-install 'auto-compile)
(ia/package-install 'breadcrumb)
(ia/package-install 'vundo)

(provide 'init-package-install)
;;; init-package-install.el ends here
