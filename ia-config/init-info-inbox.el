;;; init-info-inbox.el --- Online subscription inbox setup  -*- lexical-binding: t; -*-

;;; Commentary:
;; 

;;; Code:

(ia/feat-chunk ia-setup/elfeed t
  (with-eval-after-load 'elfeed
    (add-hook 'elfeed-new-entry-hook (elfeed-make-tagger :feed-url "youtube\\.com" :add '(video youtube)))
    ;; prevent youtube blocking on excessive connection requests.
    (setq elfeed-curl-max-connections 8)
    (setq elfeed-use-curl t)
    (with-eval-after-load 'elfeed-tube
      (setq elfeed-tube-backend 'yt-dlp)
      (elfeed-tube-setup)
      (with-eval-after-load 'elfeed-tube-mpv
        (add-to-list 'elfeed-tube-mpv-options "--volume=74" t)
        (add-to-list 'elfeed-tube-mpv-options "--loop-file=inf" t)
        ;; Youtube video loading too slow
        ;; https://github.com/mpv-player/mpv/issues/12254
        (add-to-list 'elfeed-tube-mpv-options "--ytdl-raw-options=format-sort=proto:m3u8" t)
        ;; normalize volumes for videos too load or too quiet.
        (add-to-list 'elfeed-tube-mpv-options "--af=loudnorm=I=-16:LRA=30:TP=-1.5" t)
        (add-hook 'elfeed-show-mode-hook 'elfeed-tube-mpv-follow-mode))
      (with-eval-after-load 'ia-elfeed-modified
        (setopt ia/elfeed-modified-show-entry-enable-display-buffer t)
        (ia/elfeed-modified-mode +1)))))

(provide 'init-info-inbox)

;;; init-inbox.el ends here
