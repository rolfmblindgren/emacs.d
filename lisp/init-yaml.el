;;; init-yaml.el --- YAML + LSP setup -*- lexical-binding: t; -*-

(require 'init-compat)
(declare-function lsp-format-buffer "lsp-mode" ())
(declare-function lsp-enable-which-key-integration "lsp-mode" (&optional all-modes))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-log-io nil
        lsp-headerline-breadcrumb-enable nil
        lsp-idle-delay 0.2
        lsp-completion-provider :capf)
  :config
  (unless (executable-find "yaml-language-server")
    (message "Tips: npm i -g yaml-language-server")))

(use-package highlight-indent-guides
  :hook (yaml-ts-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character))

(use-package yaml-ts-mode
  :mode ("\\.ya?ml\\'" . yaml-ts-mode)
  :hook ((yaml-ts-mode . lsp-deferred)
         (yaml-ts-mode . highlight-indent-guides-mode)))

(with-eval-after-load 'lsp-mode
  (lsp-enable-which-key-integration t))

(setq lsp-yaml-schemas
      '(:https://json.schemastore.org/github-workflow.json "/.github/workflows/*"
        :https://json.schemastore.org/github-action.json "/.github/actions/*"))

(setq lsp-yaml-format-enable t
      lsp-yaml-key-ordering nil
      lsp-yaml-completion t)

(defun roffe/yaml-format-buffer-maybe ()
  (when (bound-and-true-p lsp-mode)
    (lsp-format-buffer)))

(add-hook 'yaml-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'roffe/yaml-format-buffer-maybe nil t)))

(provide 'init-yaml)
;;; init-yaml.el ends here
