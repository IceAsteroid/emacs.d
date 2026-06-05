;;;; init-org.el --- Org-mode related configuration.  -*- lexical-binding: t; -*-


;;; Commentary:
;; 

(require 'init-common)

;;; Code:

(ia/feat-chunk ia-setup/denote t
  ;; Extra config is in `denote-modified'.
  (with-eval-after-load 'denote
    (setq denote-history-completion-in-prompts t)
    (setq denote-infer-keywords t)
    (setq denote-file-type 'org)
    (with-eval-after-load 'denote-silo
      (with-eval-after-load 'org
        (setq denote-silo-directories
              (flatten-tree (list "~/OrgWiki/SiloDiary_ZH"
                                  org-agenda-files)))))
    (with-eval-after-load 'consult-notes
      (consult-notes-denote-mode 1))))

(ia/feat-chunk ia-setup/consult-org t
  (with-eval-after-load 'consult-org
    (defun ia-advice/consult-org-heading-after (&rest _)
      "Fold all sublevel entries execpt the selected entry and its parent entires."
      (org-fold-hide-sublevels 1)
      (org-fold-show-entry)
      (org-fold-show-children)
      (org-fold-show-siblings))
    (advice-add 'consult-org-heading :after 'ia-advice/consult-org-heading-after)))

(ia/feat-chunk ia-setup/org-mode t
  (with-eval-after-load 'org
    (setq org-startup-truncated nil)
    (setq org-startup-folded 'fold)
    (setq org-hide-block-startup t)
    (setq org-hide-emphasis-markers t)
    (setq org-ellipsis "…")))

(ia/feat-chunk ia-setup/org-superstar t
  (with-eval-after-load 'org-superstar
    (setq org-superstar-remove-leading-stars t)
    ;; Full-width A B C D..
    (setq org-superstar-headline-bullets-list
          '(65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84))
    (setq org-superstar-item-bullet-alist '((?* . ?◩) (?+ . ?■) (?- . ?◧)))
    (add-hook 'org-mode-hook 'org-superstar-mode)))

(ia/feat-chunk ia-setup/consult-outline-org-preselect-nearest t
  "Preselect the nearest heading for `consult-outline' & `consult-org'."
  (defvar consult--previous-point nil
    "Location of point before entering minibuffer.
Used to preselect nearest headings and imenu items.")
  ;; `consult-imenu--cache' maps to `vertico--candidates', but the marker positions
  ;; are not sorted. This is the best approximation thus far, because
  ;; `vertico--candidates' from `consult-imenu' doesn't contain position.
  (defvar consult--previous-imenu-cache nil
    "Stores the consult-imenu--cache before entering minibuffer. Serves as a
proxy for `vertico--candidates', which for imenu does not include locations.")

  (defun consult--set-previous-point (&rest _)
    "Save location of point before entering the minibuffer."
    (setq consult--previous-point (point)))

  (defun consult--set-previous-imenu-cache (&rest _)
    "Save imenu cache before entering the minibuffer."
    (setq consult--previous-imenu-cache consult-imenu--cache))

  (advice-add #'consult-outline :before #'consult--set-previous-point)
  (advice-add #'consult-org-heading :before #'consult--set-previous-point)
  (advice-add #'consult-imenu :before #'consult--set-previous-point)
  ;; NOTE: `consult-imenu--items' sets the cache, but we're not yet in the
  ;; minibuffer, so buffer-local values are still available:
  (advice-add #'consult-imenu--items :after #'consult--set-previous-imenu-cache)
  (advice-add #'vertico--update :after #'consult-vertico--update-dispatch)

  (defun consult-vertico--update-dispatch (&rest _)
    "Dispatch from minibuffer to a few specialized commands to change how
 vertico handles candidates."
    (cl-case current-minibuffer-command
      (consult-outline
       (consult-vertico--outline-update-choose))
      (consult-org-heading
       (consult-vertico--outline-update-choose))
      (consult-imenu
       (consult-vertico--imenu-update-choose))))

;; (defun consult-vertico--outline-update-choose ()
;;   "Pick the nearest outline candidate rather than the first after updating candidates."
;;   (when consult--previous-point
;;     (setq vertico--index
;;           (max 0 ; if none above, choose the first below
;;                (1- (or (seq-position
;;                         vertico--candidates
;;                         consult--previous-point
;;                         (lambda (cand point-pos) ; counts on candidate list being sorted
;;                           (> (cl-case current-minibuffer-command
;;                                (consult-outline
;;                                 (car (consult--get-location cand)))
;;                                (consult-org-heading
;;                                 (get-text-property 0 'consult--candidate cand)))
;;                              point-pos)))
;;                        (length vertico--candidates))))))
;;   (setq consult--previous-point nil))

  ;; Revise and understand the fixes by Gemini, and then commit changes to upstream.
  (defun consult-vertico--outline-update-choose ()
    "Pick the nearest outline candidate rather than the first after updating candidates."
    (when consult--previous-point
      (setq vertico--index
            (max 0 ; if none above, choose the first below
                 (1- (or (seq-position
                          vertico--candidates
                          consult--previous-point
                          (lambda (cand point-pos) ; counts on candidate list being sorted
                            ;; CHANGED 1: Wrapped the property extraction in a `let` binding.
                            ;; We assign the result to `cand-pos` so we can check if it's nil
                            ;; before trying to run math operators on it.
                            (let ((cand-pos (cl-case current-minibuffer-command
                                              (consult-outline
                                               ;; CHANGED 2: Upgraded `car` to `car-safe`.
                                               ;; If `consult--get-location` ever unexpectedly returns nil,
                                               ;; this prevents a (wrong-type-argument listp nil) crash.
                                               (car-safe (consult--get-location cand)))
                                              (consult-org-heading
                                               ;; CHANGED 3: Swapped 'consult--candidate for 'org-marker.
                                               ;; `consult-org-heading` stores its buffer location marker here.
                                               (get-text-property 0 'org-marker cand)))))
                              ;; CHANGED 4: Added the `(and cand-pos ...)` safety net.
                              ;; Instead of blindly running `> cand-pos point-pos` (which crashes if nil),
                              ;; this safely skips the comparison entirely if `cand-pos` failed to resolve.
                              (and cand-pos (> cand-pos point-pos)))))
                         (length vertico--candidates))))))
    (setq consult--previous-point nil))

(defun consult-vertico--imenu-update-choose ()
  "Pick the nearest imenu candidate rather than the first after updating candidates."
  (when (and consult--previous-point
             consult--previous-imenu-cache)
    (setq vertico--index
          (let ((mindist most-positive-fixnum) (index 0))
            (dotimes (i (length (cdr consult--previous-imenu-cache)))
              (progn (setq dist (abs (- consult--previous-point
                                        (cdr (elt (cdr consult--previous-imenu-cache) i)))))
                     (when (< dist mindist)
                       (setq index i
                             mindist dist))))
            index)))
  (setq consult--previous-point nil
        consult--previous-imenu-cache nil)))

(provide 'init-org)
;;; init-org.el ends here
