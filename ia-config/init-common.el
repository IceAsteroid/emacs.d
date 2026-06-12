;;; init-common.el --- Common features used in the configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Purpose-specific snippets are in my emacs-utils repo.

;;; TODO:
;; Thinking whether or not to move snippets that are non-dependent to other conf files to my emacs-utils repo.

;;; Code:

;;;; Frequent used in configuration
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

;;;; Window Management
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

;;;; Tab & Frame Management
(ia/feat-chunk tab-bar t
  ;; This feature is achieved by the heavy help of Gemini Flash Extended Model.
  (defun my/tab-bar--indexed-candidates ()
    "Generate a clean alist of (\"[index] name\" . index) for all tabs."
    (cl-loop for tab in (tab-bar-tabs)
             for idx from 1
             collect (cons (format "[%d] %s" idx (alist-get 'name tab)) idx)))

  (defun ia/consult-tab-switch ()
    "Switch tab-bar tabs using live previews, or create a new tab if no match."
    (interactive)
    (unless tab-bar-mode
      (user-error "Tab-bar-mode is not active"))
    (let* ((candidates (my/tab-bar--indexed-candidates))
           (current-idx (1+ (tab-bar--current-tab-index)))
           (default-cand (car (rassq current-idx candidates)))
           (orig-tabs (copy-tree (frame-parameter nil 'tabs)))
           (orig-wc (current-window-configuration))
           (selected-key
            (unwind-protect
                (consult--read
                 candidates
                 :prompt "Switch Workspace (or create new): "
                 :default default-cand
                 :category 'tab
                 :require-match nil  ; Allow arbitrary text for new tabs
                 :state (lambda (action cand)
                          (when (and (eq action 'preview) cand)
                            (let ((target-idx (cdr (assoc cand candidates))))
                              (when target-idx
                                (tab-bar-select-tab target-idx))))))
              (set-frame-parameter nil 'tabs orig-tabs)
              (set-window-configuration orig-wc))))
      ;; Execution Phase
      (when (and selected-key (not (string= selected-key "")))
        (let ((final-idx (cdr (assoc selected-key candidates))))
          (if final-idx
              ;; Found an existing indexed tab -> switch to it
              (tab-bar-select-tab final-idx)
            ;; No match found -> safely provision a new workspace
            (tab-bar-new-tab)
            (tab-bar-rename-tab selected-key))))))

  (defun ia-advice/tab-bar-switch-indexed-override ()
    "Collision-free override for the built-in `tab-bar-switch-to-tab` command."
    (interactive)
    (let* ((candidates (my/tab-bar--indexed-candidates))
         (current-idx (1+ (tab-bar--current-tab-index)))
         (default-cand (car (rassq current-idx candidates))))
    (if (null candidates)
        (user-error "No active tabs found")
      (let* ((selected (completing-read "Switch to tab: "
                                        candidates ;; Native alist optimization
                                        nil t nil 'tab-bar-history default-cand))
             (target-idx (cdr (assoc selected candidates))))
        (if target-idx
            (tab-bar-select-tab target-idx)
          (user-error "Invalid tab selected"))))))

  (defcustom ia/tab-switch-binding "C-x t RET"
    "Key string used to trigger `ia/consult-tab-switch` when the mode is active."
    :type 'string
    :group 'tab-bar)

  (define-minor-mode ia/tab-bar-setup-mode
    "Global minor mode to manage index-safe tab switching and built-in overrides."
    :global t
    :group 'tab-bar
    ;; 1. Use the built-in inline keymap generator safely linked to your defcustom
    :keymap (let ((map (make-sparse-keymap)))
              (when (and ia/tab-switch-binding (not (string= ia/tab-switch-binding "")))
                (keymap-set map ia/tab-switch-binding 'ia/consult-tab-switch))
              map)
    ;; 2. Body handles only the volatile advice engine state toggles
    (if ia/tab-bar-setup-mode
        (advice-add 'tab-bar-switch-to-tab :override 'ia-advice/tab-bar-switch-indexed-override)
      (advice-remove 'tab-bar-switch-to-tab 'ia-advice/tab-bar-switch-indexed-override))))

;;;; Buffer
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

;;;; Org-mode

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

;;;; Theme

(ia/feat-chunk ia-deploy/persist-set-faces t
  (defvar ia/persist-set-faces--timer nil)
  (defvar ia/persist-set-faces-debounce 0.005
    "Debounce to set the faces after a theme loads.
To prevent to set the faces before the theme finishes loading.")
  (defvar ia/persist-set-faces--registry nil
    "List of functions to execute when a theme changes.")

  (defun ia-timer/persist-set-faces--set (&rest _)
    "Debounce theme switches and execute all registered face overrides."
    (when (timerp ia/persist-set-faces--timer)
      (cancel-timer ia/persist-set-faces--timer))
    (setq ia/persist-set-faces--timer
          (run-with-timer
           ia/persist-set-faces-debounce nil
           (lambda ()
             (let ((inhibit-redisplay t))
               (mapc #'funcall ia/persist-set-faces--registry))))))
  ;; Set faces each time after a theme loads.
  (advice-add 'enable-theme :after #'ia-timer/persist-set-faces--set)
  ;; For when switching back to the `default’ theme.
  (advice-add 'disable-theme :after #'ia-timer/persist-set-faces--set)

  (defmacro ia/theme-set-faces (&rest faces)
    "Define persistent face overrides. Works like `custom-set-faces'.
Can be called multiple times, handles quotes, and prevents registry bloat.

Each element in FACES should be of the form:
  '(FACE [KEYWORD VALUE]...)
Or:
  '(:eval BODY...)"
    (declare (indent 0))
    (let* ((unwrapped-faces
            (mapcar (lambda (f) (if (eq (car-safe f) 'quote) (cadr f) f)) faces))
           ;; Extract face names to create a unique, deterministic hash signature
           (face-identifiers (mapcar (lambda (f) (if (eq (car f) :eval) 'eval (car f))) unwrapped-faces))
           (hash-str (md5 (format "%S" face-identifiers)))
           (func-sym (intern (format "ia/theme-faces-gen-%s" (substring hash-str 0 8))))
           (body
            (mapcar
             (lambda (spec)
               (if (eq (car spec) :eval)
                   `(progn ,@(cdr spec))
                 `(set-face-attribute ',(car spec) nil ,@(cdr spec))))
             unwrapped-faces)))
      `(progn
         ;; Function generated to be used in `ia-timer/persist-set-faces--set' when a theme loads.
         (defun ,func-sym ()
           ,(format "Automatically generated theme overrides for: %s" face-identifiers)
           ,@body)
         (add-to-list 'ia/persist-set-faces--registry ',func-sym)
         (,func-sym)))))

;;;; Misc

(defvar-local ia/variable-pitch-mode nil)
(defun ia/variable-pitch-mode-p ()
  (if (and (bound-and-true-p buffer-face-mode)
           (eq buffer-face-mode-face
               'variable-pitch))
      (setq-local ia/variable-pitch-mode t)
    (setq-local ia/variable-pitch-mode nil)))
(add-hook 'buffer-face-mode-hook 'ia/variable-pitch-mode-p)

(defun ia/mark-things-at-point ()
  "Mark symbol at point.
If repeated, expand to sexp, then list, then line, then defun."
  (interactive)
  (if (and (eq last-command this-command) (use-region-p))
      ;; -- EXPANSION PHASE --
      ;; Define a hierarchy of things to expand into
      (let ((hierarchy '(sexp list line defun buffer))
            (rb (region-beginning))
            (re (region-end))
            (expanded nil))
        (dolist (thing hierarchy)
          (unless expanded
            (let ((bounds (bounds-of-thing-at-point thing)))
              ;; Check if the new bounds are actually larger than current region
              (when (and bounds
                         (or (< (car bounds) rb)
                             (> (cdr bounds) re)))
                (goto-char (car bounds))
                (set-mark (cdr bounds))
                (setq expanded t)
                (message "Expanded to %s" thing))))))
    ;; -- INITIAL PHASE --
    ;; Just mark the symbol
    (when-let ((b (bounds-of-thing-at-point 'symbol)))
      (goto-char (car b))
      (set-mark (cdr b))
      (message "Marked symbol"))))


(provide 'init-common)
;;; init-common.el ends here
