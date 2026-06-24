;;; init-programming.el --- Programming configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:

(electric-pair-mode +1)
(setq eldoc-echo-area-use-multiline-p t)

(ia/feat-chunk ia-setup/indentation t
  ;; Note: If `indent-tabs-mode' is enabled, and a buffer's indentation
  ;; is set to a length that differs from `tab-width', An indentation
  ;; has a chance to mix spaces and tabs.
  ;;
  ;; For example: `tab-width' sets to 4 and `sh-basic-offset' sets to
  ;; 6, an indentation will mix with a tab and 2 spaces.
  ;;
  ;; Case 1: Still consistent for different indent levesl for
  ;; different configs.  For example, if `tab-width' set to 6, a tab
  ;; character displays in 6 columns. An indent is 8 columns (6 + 2).
  ;;
  ;; Case 2: A MORE SEVERE INCONSISTENCY destroys the visual hierarchy
  ;; across different indentation levels.
  ;;
  ;; If a file written with `tab-width' set to 8 and an offset set to
  ;; 4, with `indent-tabs-mode' enabled:
  ;;
  ;; Level 1 indent (4 columns)
  ;; Level 2 indent (8 columns)
  ;;
  ;; To the author, this looks consistent. Because 4 is less than 8,
  ;; Emacs uses 4 spaces for Level 1. Level 2 hits exactly 8 columns,
  ;; Emacs swaps to using 1 tab character.
  ;;
  ;; But if someone opens this file with `tab-width' set to 4:
  ;;
  ;; Level 1 (4 columns)
  ;; Level 2 (4 columns)
  ;;
  ;; Verdict: A buffer should use either all spaces or all tabs for
  ;; indentations but not them mixed.
  ;;
  ;; 1. To use tab-only indents, enable `indent-tabs-mode', and
  ;; set `standard-indent' and all offsets for languages, equal to or
  ;; multiples of `tab-width', so only tabs and no spaces will be
  ;; inserted.
  ;;
  ;; 2: To use space-only indents, disable `indent-tabs-mode' to use
  ;; spaces to indent. And use the default 8 columns for
  ;; `tab-width' in case to display other people's source files.

  ;; insert spaces instead of tabs by default when indenting.
  (setopt indent-tabs-mode nil)
  ;; set the default 8 columns long.
  (setopt tab-width 8)
  ;; failsafe indent columns when a major mode does not have its own
  ;; indentation.
  (setopt standard-indent 4)
  ;; shell mode indentation
  (setopt sh-basic-offset 2))

(defun ia-hook/prog-mode-minor-modes ()
  (display-fill-column-indicator-mode +1)
  (flymake-mode +1))
(add-hook 'prog-mode-hook 'ia-hook/prog-mode-minor-modes)

(ia/feat-chunk ia-setup/emacs-lisp-mode t
  (setq elisp-flymake-byte-compile-load-path load-path)
  (with-eval-after-load 'checkdoc
    (defun ia-hook/emacs-lisp-mode-minor-modes ()
      (checkdoc-minor-mode +1)))
  (add-hook 'emacs-lisp-mode 'ia-hook/emacs-lisp-mode-minor-modes))

(ia/feat-chunk ia-setup/zig-mode t
  ;; I use `super-save', it saves buffer for actions like buffer
  ;; switch, making the format on save unpredictable.
  ;;
  ;; Hook the format command in `tedit-toggle-before-save-buffer-hook'
  ;; locally in a zig buffer instead for predictable format timing.
  (setopt zig-format-on-save nil)
  (with-eval-after-load 'zig-mode
    (defun ia-hook/tedit-before-save-in-zig-mode ()
      "Hooked locally in `tedit-toggle-before-save-buffer-hook' in a zig buffer."
      (zig-format-buffer))
    (defun ia-hook/zig-mode-tedit ()
      (add-hook 'tedit-toggle-before-save-buffer-hook 'ia-hook/tedit-before-save-in-zig-mode nil t))
    (add-hook 'zig-mode-hook 'ia-hook/zig-mode-tedit)))

(ia/feat-chunk ia-setup/dired t
  (with-eval-after-load 'dired
    (setq dired-listing-switches
          "-alhv --color=always --group-directories-first --time-style=long-iso")
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
      (dirvish-side-follow-mode)))
  )

(ia/feat-chunk ia-setup/xref t
  (with-eval-after-load 'consult
    ;; Use Consult to select xref locations with preview. Useful when
    ;; multiple definitions are found.
    (setopt xref-show-xrefs-function #'consult-xref)
    (setopt xref-show-definitions-function #'consult-xref)))

(ia/feat-chunk eglot t
  ;; Use use-package here becuase its hook configuration is cleaner.
  (use-package eglot
    :config
    ;; Improve performance by not loading content in its log buffer.
    ;; https://old.reddit.com/r/emacs/comments/16vixg6/how_to_make_lsp_and_eglot_way_faster_like_neovim/
    (setq eglot-events-buffer-config '(:size 0 :format full))
    (fset #'jsonrpc--log-event #'ignore)
    (setq eglot-sync-connect 0)

    ;; Set up modes that are not yet configured in `eglot-server-programs'.
    ;; zig-ts-mode.
    (setq eglot-server-programs (delete '(zig-mode "zls") eglot-server-programs))
    (add-to-list 'eglot-server-programs '((zig-mode zig-ts-mode) "zls"))

    ;; If an lsp server returns incomplete candidates while you keep
    ;; typing after corfu pops up.
    ;;
    ;; You need to refer to:
    ;; https://old.reddit.com/r/emacs/comments/1qc7f35/setting_up_lsps_and_completions_eglot_with_cape/
    ;; https://github.com/minad/corfu/wiki#continuously-update-the-candidates
    ;;
    ;; Solutions:
    ;; 1. wrap `eglot-completion-at-point' adviced with `cape-wrap-buster'.
    ;;
    ;; 2. Replace the default `completion-at-point-functions' managed
    ;; by eglot, explicitly wrap `eglot-completion-at-point' in
    ;; `cape-capf-buster' in `completion-at-point-functions'
    ;;
    ;; 3. Configure per lsp server (much faster), with
    ;; `eglot-workspace-configuration', to extend the maximum
    ;; candidates when corfu pops up, so the continuous typing has
    ;; higher chances to have intended candidates cached.
    ;;
    ;; Corfu uses caching for its completion table once pops up, as
    ;; user keeps typing, the candidates may not be updated as as
    ;; eglot does not corporate well with corfu to inform lsp server
    ;; to update the candidate table.

    (setq eglot-autoshutdown t)
    ;; Let Eglot not manage `imenu'. When a function contains faulty
    ;; syntax, strict LSP parsers fail and drop the function from the
    ;; imenu list entirely.
    ;;
    ;; NOTE: Tree-sitter (*-ts-mode) suffers from the exact same
    ;; issue, it re-labels broken functions as ERROR nodes, hiding
    ;; them. By keeping Eglot out. Overall treesitter still has better
    ;; tolerance for faulty syntax than LSP parsers.
    (add-to-list 'eglot-stay-out-of 'imenu)
    ()
    :hook
    ((sh-mode rust-mode zig-mode zig-ts-mode) . eglot-ensure)))


(provide 'init-programming)

;;; init-programming.el ends here
