;;; init-linguistics.el --- Linguistic & translation tool configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; 

(require 'init-common)

(ia/feat-chunk ia-setup/spell-check t
  (with-eval-after-load 'ispell
    (setq ispell-program-name "hunspell"))
  (with-eval-after-load 'jinx
    (setq jinx-languages "en_US")
    (global-jinx-mode +1))
)

(ia/feat-chunk ia-setup/go-translate t
  (with-eval-after-load 'gt
    ;; go-translate can have presets, the feature needs to configure to add
    ;; (setq gt-http-backend (pdd-url-backend :proxy "socks5://127.0.0.1:1080"))
    (setq gt-langs '(en zh))
    (setq gt-default-translator
          (gt-translator
           :taker
           (list
            (gt-taker :langs '(en zh) :prompt t :pick 'sentence :if '(and not-word selection))
            (gt-taker :langs '(en zh) :prompt t :text 'word :pick 'word :if '(and word selection))
            (gt-taker :langs '(en zh) :prompt t :text "" :if '(pdf-view-mode))
            (gt-taker :langs '(en zh) :prompt t :text "" :if 'not-selection))
           :engines (list ;;(gt-google-engine :if 'word)
                     (gt-google-engine :cache 'word))
           :render  (gt-buffer-render)))))


(provide 'init-linguistics)

;;; init-linguistics.el ends here
