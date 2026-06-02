;;;; init-common.el --- Common features used in the configuration -*- lexical-binding: t -*-


;;; Commentary:
;; Purpose-specific snippets are in my emacs-utils repo.

;;; TODO:
;; Thinking whether or not to move snippets that are non-dependent to other conf files to my emacs-utils repo.

;;; Code:

;;; Frequent used in configuration
(defmacro ia/feat-chunk (name enable-p &rest body)
  "A wrapper to group related config by NAME. Executes BODY if ENABLED-P is non-nil"
  (declare (indent 2))
  (when (eval enable-p)
    `(progn ,@body)))

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

;;; Window Management
(defvar ia/other-window-mru-args '(nil 'dedicated 'not-selected 'no-other)
  "A list of arguments in the order that are passed to `get-mru-window' in `ia/other-window-mru'.")
(defun ia/other-window-mru ()
  "Cycle on most recently used live windows. Arguments refer to `get-mru-window’."
  (interactive)
  ;; Selecting windows with `select-window’ doesn’t trigger to run
  ;; `mouse-leave-buffer-hook’, unlike `other-window’, which is recorded by
  ;; "auto-select-window" feature that runs hooks like
  ;; `mouse-leave-buffer-hook’.
  (run-hooks 'mouse-leave-buffer-hook)
  (when-let ((mru-window (apply 'get-mru-window ia/other-window-mru-args)))
    (select-window mru-window nil)
    ;; Always return nil
    nil))

;;; Buffer
(defun ia/count-total-lines ()
  "Like `count-lines-page', but count for all lines(logically) in a buffer."
  (interactive)
  (save-restriction
    (widen)
    (let ((total (count-lines (point-min) (point-max)))
          (before (count-lines (point-min) (point)))
          (after (count-lines (point) (point-max))))
      (message (ngettext "Buffer has total %d line (%d + %d)"
                         "Buffer has total %d lines (%d + %d)"
                         total)
               total before after))))

;;; Org-mode

;; Consider taking this code to its own repo or in my emacs-util repo.
;; Deploy functions to hide/show contexts of items in org-mode
;; The implementation needs refactor when I get time
(ia/feat-chunk ia-deploy/org-item t
  (with-eval-after-load 'org
    (defvar my/org-fold-hide-item-cycle-view-list '(folded children subtree)
      "List of view states for items to cycle.")
    (defvar my/org-fold-hide-item-cycle-view 'folded
      "Default view state for first run as in `my/org-fold-hide-item-cycle-view-list'")
    (defun ia/org-item-nesting-level (item)
      "Return the nesting level of an Org ITEM.
A first-level item returns 1, a nested item returns 2, and so on.  ITEM should
be an element of type 'item produced by `org-element-parse-buffer`."
      (let ((level 1)
            ;; The direct parent of an 'item is a plain-list.
            (parent (org-element-property :parent item)))
        (while (and parent (eq (org-element-type parent) 'plain-list))
          ;; The plain-list’s parent is the item that contained it, if any.
          (let ((upper (org-element-property :parent parent)))
            (if (and upper (eq (org-element-type upper) 'item))
                (progn
                  (setq level (1+ level))
                  ;; And now set parent to the plain-list of that ancestor item.
                  (setq parent (org-element-property :parent upper)))
              (setq parent nil))))
        level))
    (defun ia/org-item-map (function &optional start end level only-visible)
      "Act like `org-map-entries' for items which moves point to each item line and applies the function to it in org-mode.
`start' & `end' specify the beginning & end positions for mapping.  `level'
limits to the level item to map to.  `only-visible' if is t, map only to visbile
item lines(unfolded), otherwise to all item lines."
      (let* ((start (or start (point-min)))
             (end (or end (point-max))))
        (save-restriction
          (narrow-to-region start end)
          (org-element-map (org-element-parse-buffer) 'item
            (lambda (item)
              (save-excursion
                (goto-char (org-element-property :begin item))
                ;; Move forwawrd one char as the first char's property in a item
                ;; line is a plain list instead of the item's.
                (forward-char 1)
                (when (or (not level)
                          (<= (ia/org-item-nesting-level item)
                              level))
                  (if only-visible
                      (unless (get-char-property (point) 'invisible)
                        (funcall function item))
                    (funcall function item)
                    ))))))))
    (defun ia/org-fold-hide-item-all (&optional view)
      (interactive)
      (let ((view (or view 'folded)))
        (ia/org-item-map
         (lambda (&rest _)
           (org-list-set-item-visibility (line-beginning-position) (org-list-struct) view))
         nil nil 1 'only-visible)
        (setq my/org-fold-hide-item-cycle-view view)
        (message "Item view: %s" view)
        ))
    (defun ia/org-fold-hide-item-toggle ()
      (interactive)
      (let ((next-view (or (cadr (member my/org-fold-hide-item-cycle-view
                                         my/org-fold-hide-item-cycle-view-list))
                           ;; If in a last elem as its next elem is nil, return
                           ;; the first elem of the list.
                           (car my/org-fold-hide-item-cycle-view-list))))
        (if (eq this-command last-command)
            (ia/org-fold-hide-item-all next-view)
          (setq my/org-fold-hide-item-cycle-view 'folded)
          (ia/org-fold-hide-item-all my/org-fold-hide-item-cycle-view))))))

(defvar-local ia/variable-pitch-mode nil)
(defun ia/variable-pitch-mode-p ()
  (if (and (bound-and-true-p buffer-face-mode)
           (eq buffer-face-mode-face
               'variable-pitch))
      (setq-local ia/variable-pitch-mode t)
    (setq-local ia/variable-pitch-mode nil)))
(add-hook 'buffer-face-mode-hook 'ia/variable-pitch-mode-p)


(provide 'init-common)
;;; init-common.el ends here
