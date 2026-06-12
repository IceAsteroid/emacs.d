;;; init-programming.el --- Programming configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:

(electric-pair-mode +1)

(defun ia-hook/prog-mode-minor-modes ()
  (display-fill-column-indicator-mode +1)
  (flymake-mode +1))
(add-hook 'prog-mode-hook 'ia-hook/prog-mode-minor-modes)

(defun ia-hook/emacs-lisp-mode-minor-modes ()
  (checkdoc-minor-mode +1))
(add-hook 'emacs-lisp-mode 'ia-hook/emacs-lisp-mode-minor-modes)

(setq eldoc-echo-area-use-multiline-p t)

(ia/feat-chunk dirvish t
  (with-eval-after-load 'dirvish
    (setq dirvish-subtree-state-style 'plus)
    (setq dirvish-side-width 30)
    ;; set height nil to align to any theme's different height.
    (setq dirvish-mode-line-height nil)
    (setq dirvish-attributes
          '(file-modes git-msg vc-state file-time file-size subtree-state))
    (setq dirvish-side-attributes
          '(vc-state subtree-state))
    (dirvish-override-dired-mode +1)
    (dirvish-side-follow-mode)))

(ia/feat-chunk eglot t
  (use-package eglot
    :config
    ;; Improve performance by not loading content in its log buffer.
    ;; https://old.reddit.com/r/emacs/comments/16vixg6/how_to_make_lsp_and_eglot_way_faster_like_neovim/
    (setq eglot-events-buffer-config '(:size 0 :format full))
    (fset #'jsonrpc--log-event #'ignore)
    (setq eglot-sync-connect 0)

    (setq eglot-autoshutdown t)
    :hook
    ((sh-mode rust-mode) . eglot-ensure)))


(provide 'init-programming)

;;; init-programming.el ends here
