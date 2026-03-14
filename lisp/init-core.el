;;; init-core.el --- core settings and utilities -*- lexical-binding: t; -*-

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "ANTHROPIC_API_KEY")
  (exec-path-from-shell-copy-env "OPENAI_API_KEY"))

(when (memq window-system '(mac ns x))
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setenv "PATH" (concat "/Library/TeX/texbin/:" (getenv "PATH")))

(require 'dired)

(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(defun get-default-height ()
  (/ (display-pixel-height)
     (frame-char-height)))

(add-to-list 'default-frame-alist '(width . 80))
(add-to-list 'default-frame-alist (cons 'height (get-default-height)))

(global-unset-key (kbd "C-z"))

(setq mac-option-key-is-meta nil)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

(setq treesit-extra-load-path
      (list (expand-file-name "Library/Application Support/tree-sitter"
                              (getenv "HOME"))))

(setq dired-use-ls-dired nil)

(mapc #'frame-width
      (frames-on-display-list))

(add-hook 'before-make-frame-hook
          (lambda ()
            (let* ((all-frames (frames-on-display-list))
                   (rightmost-left 0))
              (dolist (frame all-frames)
                (let ((frame-left (frame-parameter frame 'left))
                      (frame-width (frame-pixel-width frame)))
                  (setq rightmost-left
                        (max rightmost-left (+ frame-left frame-width)))))
              (add-to-list 'default-frame-alist `(left . ,rightmost-left))
              (add-to-list 'default-frame-alist '(top . 0)))))

(add-to-list 'default-frame-alist
             `(height . ,(/ (display-pixel-height) (line-pixel-height))))

(dolist (path '("/usr/local/bin" "/opt/homebrew/bin" "/Library/TeX/texbin"))
  (setenv "PATH" (concat path ":" (getenv "PATH"))))

(setenv "LC_ALL" "en_US.UTF-8")

(setq tramp-default-method "sshx")

(defun rb/byte-compile-init-files ()
  "Byte-kompiler `init.el` og modulene under `lisp/` i trygg rekkefølge."
  (interactive)
  (let* ((root user-emacs-directory)
         (lisp-dir (expand-file-name "lisp" root))
         (module-files (sort (directory-files lisp-dir t "\\`init-.*\\.el\\'")
                             #'string-lessp))
         (files (append module-files
                        (list (expand-file-name "init.el" root))))
         (t0 (float-time))
         (compiled 0))
    (dolist (file files)
      (when (file-regular-p file)
        (byte-compile-file file)
        (setq compiled (1+ compiled))))
    (message "Init: kompilerte %d filer på %.2fs"
             compiled
             (- (float-time) t0))))

(global-set-key (kbd "C-c e c") #'rb/byte-compile-init-files)

;; Desktop state
(setq desktop-dirname (expand-file-name "~/.emacs.d/desktop/")
      desktop-path (list desktop-dirname)
      desktop-base-file-name "emacs-desktop"
      desktop-base-lock-name "emacs-desktop.lock"
      desktop-save t
      desktop-load-locked-desktop t)

(make-directory desktop-dirname t)
(desktop-save-mode 1)

;; Magit menu shown only in git repos.
(require 'easymenu)

(defun roffe/in-git-p (&optional dir)
  "Ikke-nil hvis DIR (eller `default-directory`) ligger i et git-repo."
  (let ((d (file-name-as-directory (or dir default-directory))))
    (locate-dominating-file d ".git")))

(defvar roffe-magit-menu-mode-map
  (let ((map (make-sparse-keymap)))
    (easy-menu-define roffe/magit-menu map "Magit"
      '("Magit"
        ["Status" magit-status t]
        ["Log All" magit-log-all t]
        ["Commit" magit-commit-create t]
        ["Push" magit-push-current-to-pushremote t]
        ["Pull" magit-pull-from-upstream t]
        ["Blame" magit-blame-addition t]
        ["Quit Magit Buffers" magit-mode-bury-buffer t]))
    map)
  "Keymap som gir en Magit-meny i menylinja når minor mode er aktiv.")

(define-minor-mode roffe-magit-menu-mode
  "Vis Magit-meny i denne bufferen."
  :lighter ""
  :keymap roffe-magit-menu-mode-map)

(defun roffe/magit-menu-refresh ()
  "Skru på/av Magit-meny i current buffer basert på om den er i et git-repo."
  (if (roffe/in-git-p)
      (roffe-magit-menu-mode 1)
    (roffe-magit-menu-mode 0)))

(add-hook 'find-file-hook #'roffe/magit-menu-refresh)
(add-hook 'buffer-list-update-hook #'roffe/magit-menu-refresh)
(add-hook 'dired-mode-hook #'roffe/magit-menu-refresh)

(use-package magit
  :ensure t
  :commands (magit-status magit-log-all magit-commit-create
                          magit-push-current-to-pushremote
                          magit-pull-from-upstream
                          magit-blame-addition
                          magit-mode-bury-buffer))

(provide 'init-core)
;;; init-core.el ends here
