;;; init-packages.el --- package/bootstrap setup -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)
(require 'use-package)

(provide 'init-packages)
;;; init-packages.el ends here
