;;; init-common.el --- Common features used in the configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Purpose-specific snippets are in my emacs-utils repo.  Only
;; bootstrap features should be put here to prevent massive commits
;; for tweaking features than Emacs configuration, to have a dedicated
;; clean git history.

;;; Code:

(eval-and-compile ;; For the function below in use with macros like use-package.
  (defvar ia/local-packages-dir nil)
  (defun ia/load-dir-recursive (dir &optional sub-dir-p arg force follow-symlinks)
    "Add DIR inside the parent dir `ia/local-packages-dir` to load-path and optionally compile.
Check ARG, FORCE and FOLLOW-SYMLINKS arguments in the docstring of `byte-recompile-directory`."
    (let ((default-directory (expand-file-name dir ia/local-packages-dir)))
      (funcall 'byte-recompile-directory default-directory arg force)
      (add-to-list 'load-path default-directory)
      ;; Handle subdirectories
      (when sub-dir-p (normal-top-level-add-subdirs-to-load-path))
      ;; Return for the caller.
      default-directory)))

(provide 'init-common)
;;; init-common.el ends here
