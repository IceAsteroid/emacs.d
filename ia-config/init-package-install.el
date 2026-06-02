;;;; init-package-install.el --- Install & Initialize packages -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(defun ia/package-install (pkg)
  (unless (package-installed-p pkg)
    (package-install pkg))
  (require pkg))

;;; Performance
(ia/package-install 'gcmh)

;;; Completion
(ia/package-install 'vertico)
(ia/package-install 'marginalia)
(ia/package-install 'orderless)
(ia/package-install 'consult)

;;; Programming
(ia/package-install 'corfu)

;;; Contextual hinting
(ia/package-install 'embark)
(ia/package-install 'embark-consult)

;;; Git
(ia/package-install 'magit)

;;; Org-mode
(ia/package-install 'denote)
(ia/package-install 'denote-silo)
(ia/package-install 'consult-notes)

;;; Linguistics & Translation
(ia/package-install 'gt)


(provide 'init-package-install)
;;; init-package-install.el ends here
