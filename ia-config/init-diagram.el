;;; init-diagram.el --- Diagram tooling configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;

(require 'ia-core-utility)

;;; Code:

(ia/feat-chunk ia-setup/plantuml t
  (with-eval-after-load 'plantuml-mode
    ;; Install plantuml, and explicitly set
    ;; `plantuml-default-execution-mode' to non-`server' as a safe
    ;; measure, otherwise plantuml-mode will send local diagram code
    ;; to remote server to resolve.
    (setopt plantuml-default-exec-mode 'executable)
    (setopt plantuml-executable-path "plantuml")
    (with-eval-after-load 'ob-plantuml
      (setopt org-plantuml-exec-mode 'plantuml)
      (setopt org-plantuml-executable-path "plantuml"))))

(provide 'init-diagram)
;;; init-diagram.el ends here
