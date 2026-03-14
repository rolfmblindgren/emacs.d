;;; init-lisp.el --- Common Lisp and related tools -*- lexical-binding: t; -*-

(require 'init-compat)
(declare-function sly "sly" ())
(declare-function sly-connected-p "sly" ())

(with-eval-after-load 'sly
  (add-hook 'lisp-mode-hook
            (lambda ()
              (unless (sly-connected-p)
                (save-excursion
                  (sly))))))

(use-package sly
  :commands (sly sly-connect)
  :init
  (setq inferior-lisp-program "/opt/homebrew/bin/sbcl")
  (setq sly-complete-symbol-function 'sly-flex-completions)
  :hook
  (lisp-mode . sly-editing-mode)
  :config
  (message "Sly bruker %s" inferior-lisp-program))

(use-package sly-quicklisp
  :ensure t
  :after sly)

(use-package sly-asdf
  :ensure t
  :after sly)

(use-package common-lisp-snippets
  :vc (:url "https://github.com/mrkkrp/common-lisp-snippets"
            :branch "master")
  :after yasnippet
  :config
  (message "common-lisp-snippets loaded"))

(add-hook 'lisp-mode-hook
          (lambda ()
            (unless (sly-connected-p)
              (save-excursion
                (sly)))))

(provide 'init-lisp)
;;; init-lisp.el ends here
