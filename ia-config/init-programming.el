;;; init-programming.el --- Programming configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:

(electric-pair-mode +1)
(setq eldoc-echo-area-use-multiline-p t)

(defun ia-hook/prog-mode-minor-modes ()
  (display-fill-column-indicator-mode +1)
  (flymake-mode +1))
(add-hook 'prog-mode-hook 'ia-hook/prog-mode-minor-modes)

(ia/feat-chunk emacs-lisp-mode t
  (setq elisp-flymake-byte-compile-load-path load-path)
  (with-eval-after-load 'checkdoc
    (defun ia-hook/emacs-lisp-mode-minor-modes ()
      (checkdoc-minor-mode +1)))
  (add-hook 'emacs-lisp-mode 'ia-hook/emacs-lisp-mode-minor-modes))

(ia/feat-chunk dired t
  (with-eval-after-load 'dired
    (setq dired-listing-switches
          "-alhv --group-directories-first --time-style=long-iso")
    (setq dired-vc-rename-file t))
  (ia/feat-chunk dirvish t
    (with-eval-after-load 'dirvish
      (setq dirvish-subtree-state-style 'plus)
      (setq dirvish-side-width 30)
      ;; set height nil to align to any theme's different height.
      (setq dirvish-mode-line-height nil)
      (setq dirvish-hide-details '(dirvish-side))
      (setq dirvish-attributes
            '(symlink-target file-modes git-msg vc-state file-time file-size subtree-state))
      (setq dirvish-mode-line-format '(:right (sort omit symlink) :left (index)))
      (setq dirvish-side-attributes
            '(vc-state subtree-state))
      (dirvish-override-dired-mode +1)
      (dirvish-side-follow-mode))))

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
