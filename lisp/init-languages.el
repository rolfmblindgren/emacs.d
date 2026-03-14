;;; init-languages.el --- language modes outside TeX/Lisp/YAML -*- lexical-binding: t; -*-

(require 'init-compat)

(use-package web-mode
  :ensure t
  :mode "\\.php\\'"
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

(use-package rust-mode
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

(use-package js2-mode
  :ensure nil
  :hook (js2-mode . js2-imenu-extras-mode)
  :config
  (setq js-indent-level 2
        indent-tabs-mode nil
        standard-indent 2))

(use-package rjsx-mode
  :mode "\\.jsx?\\'"
  :interpreter "node")

(use-package polymode
  :ensure t
  :config
  (setq polymode-exporter-output-file-format "%s"
        polymode-weaver-output-file-format "%s"))

(use-package ess
  :ensure t
  :config
  (setq ess-style 'GNU
        inferior-ess-r-program
        "/Library/Frameworks/R.framework/Versions/Current/Resources/bin/R"))

(use-package lua-mode
  :ensure t
  :config
  (setq lua-default-application "/opt/homebrew/bin/lua"))

(use-package python
  :ensure t
  :config
  (setq python-indent-offset 2
        python-interpreter "/opt/homebrew/bin/python3"
        python-shell-interpreter "/opt/homebrew/bin/python3"))

(use-package ace-window
  :ensure t)

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

(push "/usr/local/src/eplot/" load-path)
(autoload 'eplot "eplot" nil t)
(autoload 'eplot-mode "eplot" nil t)
(unless (assoc "\\.plt" auto-mode-alist)
  (setq auto-mode-alist (cons '("\\.plt" . eplot-mode) auto-mode-alist)))

(setq treesit-language-source-alist
      '((typescript
         "https://github.com/tree-sitter/tree-sitter-typescript"
         "master"
         "typescript/src")
        (tsx
         "https://github.com/tree-sitter/tree-sitter-typescript"
         "master"
         "tsx/src")))

(provide 'init-languages)
;;; init-languages.el ends here
