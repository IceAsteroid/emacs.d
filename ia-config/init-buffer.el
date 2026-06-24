;;; init-buffer.el --- Buffer & Editing Configuration

;;; Commentary:
;;

;;; Code:

(ia/feat-chunk ia-setup/outline-minor-mode t
  (with-eval-after-load 'outline
    (setq outline-minor-mode-highlight t)
    ;; Enable outline minor mode in emacs-lisp-mode buffers.
    (add-hook 'emacs-lisp-mode-hook 'outline-minor-mode)))

(defun ia-hook/prog-mode-buffer-misc ()
  (setq show-trailing-whitespace t))
(add-hook 'prog-mode-hook 'ia-hook/prog-mode-buffer-misc)

(defun ia-hook/conf-mode-buffer-misc ()
  (setq show-trailing-whitespace t))
(add-hook 'conf-mode-hook 'ia-hook/conf-mode-buffer-misc)

(defun ia-hook/text-mode-buffer-misc ()
  (setq show-trailing-whitespace t))
(add-hook 'text-mode-hook 'ia-hook/text-mode-buffer-misc)

(ia/feat-chunk ia-setup/headerline t
  (ia/feat-chunk ia-setup/breadcrumb t
    (with-eval-after-load 'breadcrumb
      ;; Disable project path display.
      ;; https://github.com/joaotavora/breadcrumb/issues/27
      (fset 'breadcrumb--project-crumbs-1 'ignore)
      (setq breadcrumb-project-max-length 1.0)
      (setq breadcrumb-imenu-max-length 1.0)
      (setq breadcrumb-idle-time 0.8)
      (with-eval-after-load 'org-compat
        ;; breadcrumb uses imenu to retreive nodes.
        (setq org-imenu-depth 4))
      (with-eval-after-load 'ia-breadcrumb-modified
        (ia/breadcrumb-modified-mode +1))
      (add-hook 'prog-mode-hook 'breadcrumb-local-mode))))

(ia/feat-chunk ia-setup/treesit t
  ;; Have to put treesit here in `init-buffer.el', since it is not
  ;; strictly for source files/modes only.
  (ia/feat-chunk ia-setup/treesit-auto t
    (with-eval-after-load 'treesit-auto
      ;; Run `treesit-auto-install-all' in case you do not want to
      ;; install every time when a *-ts-mode is missing for a file.
      (setopt treesit-auto-install 'prompt)
      (treesit-auto-add-to-auto-mode-alist 'all)
      (global-treesit-auto-mode +1)))
  (ia/feat-chunk ia-setup/bash-ts-mode t
    (ia/bash-ts-modified-mode +1)))

(ia/feat-chunk ia-setup/combobulate t
  (with-eval-after-load 'combobulate
    ;; A custom bash support for combobulate-mode is defined in
    ;; `ia-combobulate-bash.el' in the emacs-utils repo.
    (setopt combobulate-key-prefix "C-c o")
    (add-hook 'prog-mode-hook #'combobulate-mode)))

(ia/feat-chunk ia-setup/isearch t
  (with-eval-after-load 'isearch
    (setopt isearch-lazy-count t)
    (setopt isearch-wrap-pause 'no)))


(provide 'init-buffer)

;;; init-buffer.el ends here
