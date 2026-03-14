;;; init.el --- init -*- lexical-binding: t; -*-

(message "init.el av %s"
         (format-time-string "%Y-%m-%d %H:%M:%S"
                             (nth 5 (file-attributes (buffer-file-name)))))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-compat)
(require 'init-packages)
(require 'init-core)
(require 'init-ai)
(require 'init-languages)
(require 'init-tex)
(require 'init-lisp)
(require 'init-yaml)
(require 'init-editing)

(let ((init-local-file (expand-file-name "lisp/init-local.el" user-emacs-directory)))
  (when (file-exists-p init-local-file)
    (load init-local-file nil 'nomessage)))

(provide 'init)
;;; init.el ends here
