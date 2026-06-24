;;; init-keybinds.el --- All custom keybinds -*- lexical-binding: t -*-

;;; Commentary:
;;

(require 'ia-core-utility)

;;; Code:

(ia/feat-chunk ia-setup/repeat-mode t
  (setq repeat-on-final-keystroke t)
  (setq set-mark-command-repeat-pop t)
  (repeat-mode 1))

(ia/feat-chunk ia-setup/window-management-keymap t
  (with-eval-after-load 'window
    ;; (keymap-set global-map "M-o" 'other-window)
    (keymap-set global-map "M-o" 'ia/other-window-mru)
    (with-eval-after-load 'windmove))

  (ia/feat-chunk ia-setup/window-prefix t
    (with-eval-after-load 'ia-window-prefix-pivot
      (keymap-set global-map "<remap> <other-window-prefix>" #'ace-other-window-prefix)))

  (ia/feat-chunk ia-setup/popper-keymap t
    (with-eval-after-load 'popper
      (defvar-keymap ctl-z-popper-map
        :doc "Keymap for `popper-mode’."
        :repeat t
        "C-z" 'popper-toggle
        "C-<tab>" 'popper-cycle
        "<tab>" 'popper-toggle-type)
      (keymap-set global-map "C-z" ctl-z-popper-map)))

  (ia/feat-chunk ia-setup/tab-line-keymap t
    (with-eval-after-load 'tab-line
      (keymap-set tab-line-mode-map "C-x S-<left>" 'tab-line-hscroll-left)
      (keymap-set tab-line-mode-map "C-x S-<right>" 'tab-line-hscroll-right)
      (keymap-set tab-line-switch-repeat-map "S-<left>" 'tab-line-hscroll-left)
      (keymap-set tab-line-switch-repeat-map "S-<right>" 'tab-line-hscroll-right)
      (put 'tab-line-hscroll-left 'repeat-map 'tab-line-switch-repeat-map)
      (put 'tab-line-hscroll-right 'repeat-map 'tab-line-switch-repeat-map)))

  (ia/feat-chunk ia-setup/tab-bar-keymap t
    (with-eval-after-load 'tab-bar
      (defvar-keymap ia/tab-bar-history-repeat-map
        :doc "Keymap to repeat tab bar history. Used in `repeat-mode'."
        :repeat t
        "<left>" #'tab-bar-history-back
        "<right>" #'tab-bar-history-forward)

      (with-eval-after-load 'ia-tab-bar-modified-consult
        (keymap-unset tab-bar-mode-map "C-<left>" 'left-word)
        (keymap-unset tab-bar-mode-map "C-<right>" 'right-word)
        (keymap-set tab-bar-mode-map "C-<left>" 'tab-previous)
        (keymap-set tab-bar-mode-map "C-<right>" 'tab-next)
        (keymap-set ia/tab-bar-modified-consult-mode-map "C-S-<left>" 'ia/tab-bar-modified-move-current-left)
        (keymap-set ia/tab-bar-modified-consult-mode-map "C-S-<right>" 'ia/tab-bar-modified-move-current-right)
        (keymap-set ia/tab-bar-modified-consult-mode-map "<remap> <tab-switch>" 'ia/consult-tab-switch))))
  )

(ia/feat-chunk ia-setup/buffer-manipulation-keymap t
  (keymap-set global-map "<remap> <list-buffers>" 'ibuffer)

  (ia/feat-chunk ia-setup/vundo-keymap t
      (with-eval-after-load 'vundo
        (keymap-set global-map "<remap> <undo-redo>" 'ia/undo-redo-before-vundo)
        (keymap-set global-map "<remap> <undo>" 'ia/undo-before-vundo)
        (keymap-set vundo-mode-map "C-/" 'vundo-backward)
        (keymap-set vundo-mode-map "C-?" 'vundo-forward)
        (keymap-set vundo-mode-map "C-b" 'vundo-backward)
        (keymap-set vundo-mode-map "C-f" 'vundo-forward)
        (keymap-set vundo-mode-map "C-p" 'vundo-previous)
        (keymap-set vundo-mode-map "C-n" 'vundo-next)))

  (ia/feat-chunk ia-setup/in-buffer-navigation-keymap t
    (ia/feat-chunk ia-setup/consult-navigation-keymap t
      (with-eval-after-load 'consult
        ;; A keybind cannot use <remap> with its original map to
        ;; indirect a command to another, because `goto-map' is a
        ;; prefix map that doesn't bind to any mode.
        ;;
        ;; 1. Use <remap> with global map. It has a drawback where it
        ;; will not show in its original map with `describe-map'.
        ;;
        ;; 2. Override, or unset it first and then set to the new
        ;; command. The new keybind can show in `describe-map'.
        (keymap-unset goto-map "i" 'imenu)
        (keymap-unset goto-map "g" 'goto-line)
        (keymap-unset goto-map "M-g" 'goto-line)
        (keymap-set goto-map "i" 'consult-imenu)
        (keymap-set goto-map "g" 'consult-goto-line)
        (keymap-set goto-map "M-g" 'consult-goto-line)
        (keymap-set global-map "<remap> <goto-line>" 'consult-goto-line)
        (keymap-set goto-map "I" 'consult-imenu-multi)
        (keymap-set goto-map "m" 'consult-mark))))

  (ia/feat-chunk ia-setup/better-deletion-keymap t
    (keymap-unset global-map "M-<backspace>" 'backward-kill-word)
    (keymap-set global-map "M-<backspace>" 'ia/backward-kill-word)
    (keymap-unset global-map "M-d" 'kill-word)
    (keymap-set global-map "M-d" 'ia/kill-word))
  )

(ia/feat-chunk ia-setup/search-keymap t
  (ia/feat-chunk ia-setup/consult-search-keymap t
    (with-eval-after-load 'consult
      (keymap-set search-map "g" 'consult-ripgrep)
      (keymap-set search-map "G" 'consult-git-grep)
      (keymap-set search-map "l" 'consult-line)
      (keymap-set search-map "L" 'consult-line-multi)))
  )

(ia/feat-chunk ia-setup/count-lines-keymap t
  (with-eval-after-load 'page
    (with-eval-after-load 'org
      (keymap-unset org-mode-map "C-x l" 'count-lines-page))
    (defvar-keymap ia/line-count-map
      :doc "Keymap for commands that cound lines."
      "L" 'count-lines-page
      "l" 'ia/count-total-lines)
    (keymap-set global-map "C-x l" ia/line-count-map)))

(ia/feat-chunk ia-setup/note-management-keymap t
  (with-eval-after-load 'denote
    (with-eval-after-load 'consult-notes
      (defvar-keymap my/denote-map
        :doc "Keymap for denote commands."
        "c" 'denote-open-or-create
        "d" 'my/denote-switch-directory
        "s" 'denote-silo-open-or-create)
      (defvar-keymap my/consult-notes-map
        :doc "Keymap for consult-notes commands."
        "n" 'consult-notes
        "s" 'consult-notes-search-in-all-notes)
      (defvar-keymap my/meta-n-map
        :doc "Keymap for note management."
        "M-N" my/consult-notes-map
        "M-D" my/denote-map)
      ;; (keymap-unset Info-mode-map "M-n" 'clone-buffer)
      (keymap-set global-map "M-N" my/meta-n-map))))

(ia/feat-chunk ia-setup/org-mode-keymap t
  (with-eval-after-load 'org
    (defvar-keymap ia/org-toggle-element-map
      :doc "Keymap for toggling org elements like links or emphasis-markers."
      "l" 'org-toggle-link-display
      "e" 'ia/org-toggle-emphasis-display)
    (keymap-set org-mode-map "C-c l" ia/org-toggle-element-map)
    (with-eval-after-load 'consult
      (keymap-set org-mode-map "C-c C-g" 'consult-org-heading))))

(ia/feat-chunk ia-setup/completion-at-point-keymap t
  (ia/feat-chunk ia-setup/corfu-keymap nil
    (with-eval-after-load 'corfu
      (keymap-unset corfu-map "M-n" 'corfu-next)
      (keymap-unset corfu-map "M-p" 'corfu-previous)
      (keymap-unset corfu-map "RET" 'corfu-insert)))

  (ia/feat-chunk ia-setup/cape-keymap t
    (with-eval-after-load 'cape
      (defun ia/cape-capf-fallsafe ()
        "Manually trigger where preceding capf functions have candidates but do not show
intended candidates that would show by next capf functions."
        (interactive)
        (cape-interactive
         (cape-capf-choose
          #'cape-file
          #'cape-dabbrev)))
      (keymap-set global-map "<remap> <dabbrev-expand>" #'ia/cape-capf-fallsafe))))

(ia/feat-chunk ia-setup/embark-keymap t
  ;; unfinished configuration.
  (keymap-set global-map "C-." 'embark-act)
  (keymap-set global-map "C-;" 'embark-dwim)
  (keymap-set embark-flymake-map "p" 'embark-previous-symbol)
  (keymap-set embark-flymake-map "n" 'embark-next-symbol)
  (keymap-set embark-flymake-map "P" 'flymake-goto-prev-error)
  (keymap-set embark-flymake-map "N" 'flymake-goto-next-error))

(ia/feat-chunk ia-setup/man-keymap t
  (keymap-set global-map "C-h M" 'man))

(ia/feat-chunk ia-setup/gt-keymap t
  (with-eval-after-load 'gt
    (keymap-unset global-map "C-h t" 'help-with-tutorial)
    (keymap-set global-map "C-h T" 'help-with-tutorial)
    (keymap-set global-map "C-h t" 'gt-translate)))

(ia/feat-chunk ia-setup/ia/mark-things-at-point-keymap t
  (with-eval-after-load 'ia-buffer-utility
    (keymap-set global-map "C->" 'ia/mark-things-at-point)))

(ia/feat-chunk ia-setup/outline-keymap t
  "Set up custom key bindings for outline minor mode using a new prefix."
  ;; Setting this variable doens’t work if `outline' has been loaded
  ;; so the following workaround is needed.
  ;; (setq outline-minor-mode-prefix "")
  (with-eval-after-load 'outline
    (keymap-set outline-minor-mode-map "C-c" outline-mode-prefix-map)
    (keymap-set outline-mode-prefix-map "C-<tab>" 'outline-cycle)
    (keymap-unset outline-mode-prefix-map "TAB" 'outline-show-children)
    (keymap-set outline-mode-prefix-map "<tab>" 'outline-cycle-buffer)
    (with-eval-after-load 'consult
      (keymap-set outline-mode-prefix-map "C-g" 'consult-outline))))

(ia/feat-chunk ia-setup/eglot-mode-keymap t
  (with-eval-after-load 'eglot
    (keymap-set eglot-mode-map "C-c d" 'eldoc-doc-buffer)
    (keymap-set eglot-mode-map "C-c a" 'eglot-code-actions)
    (keymap-set eglot-mode-map "C-c r" 'eglot-rename)))


(ia/feat-chunk ia-setup/dirvish-keymap t
  (with-eval-after-load 'dirvish
    (keymap-set global-map "C-x p t" 'dirvish-side)
    (keymap-set dirvish-mode-map "<backtab>" 'dirvish-subtree-clear)
    (keymap-set dirvish-mode-map "<tab>" 'dirvish-subtree-toggle)))

(ia/feat-chunk ia-setup/info-inbox-keymap t
  (ia/feat-chunk ia-setup/elfeed t
    (with-eval-after-load 'elfeed
      (ia/feat-chunk ia-setup/elfeed-tube t
        (with-eval-after-load 'elfeed-tube
          (keymap-set elfeed-show-mode-map "F" 'elfeed-tube-fetch)
          (keymap-set elfeed-show-mode-map "<remap> <save-buffer>" 'elfeed-tube-save)
          (keymap-set elfeed-search-mode-map "F" 'elfeed-tube-fetch)
          (keymap-set elfeed-search-mode-map "<remap> <save-buffer>" 'elfeed-tube-save)
          (with-eval-after-load 'elfeed-tube-mpv
            (keymap-unset elfeed-show-mode-map "<return>" 'shr-browse-url)
            (keymap-set elfeed-show-mode-map "C-c C-o" 'shr-browse-url)
            (keymap-set elfeed-show-mode-map "<return>" 'elfeed-tube-mpv)))))))


(provide 'init-keybinds)
;;; init-keybinds.el ends here
