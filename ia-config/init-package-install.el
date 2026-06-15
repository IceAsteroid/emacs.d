;;; init-package-install.el --- Install & Initialize packages -*- lexical-binding: t -*-

;;; Commentary:
;;

(require 'package)
(require 'ia-core-utility)

;;; Code:

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize t)


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
(ia/package-install 'shackle)

;;;; Programming
(ia/package-install 'corfu)
(ia/package-install 'cape)
(ia/package-install 'kind-icon)

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

;;;; Linguistics & Translation
(ia/package-install 'gt)
(ia/package-install 'jinx)

;;;; Documentation enhancement
(ia/package-install 'helpful)

;;;; Misc
(ia/package-install 'dirvish)
(ia/package-install 'ace-window)


(provide 'init-package-install)
;;; init-package-install.el ends here
