;;; init-editing.el --- editing helpers, completion, spelling -*- lexical-binding: t; -*-

(require 'init-compat)

(use-package ws-butler
  :ensure t
  :hook (prog-mode . ws-butler-mode))

(use-package company
  :ensure t
  :hook ((after-init . global-company-mode)
         (sly-mode . company-mode)
         (sly-mrepl-mode . company-mode))
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-tooltip-align-annotations t))

(use-package yasnippet
  :hook ((sly-mode . yas-minor-mode)
         (lisp-mode . yas-minor-mode)
         (prog-mode . yas-minor-mode)))

(use-package anddo
  :vc (:url "https://github.com/larsmagne/anddo.el"
            :branch "master")
  :config
  (message "anddo loaded"))

(defvar rb/keep-ispell-alive t
  "Hvis ikke-nil, hindrer vi at ispell-prosessen blir drept automatisk.")

(defun rb/ispell-kill-ispell-around (orig &rest args)
  (if rb/keep-ispell-alive
      nil
    (apply orig args)))

(with-eval-after-load 'ispell
  (advice-add 'ispell-kill-ispell :around #'rb/ispell-kill-ispell-around))

(use-package ispell
  :defer t
  :init
  (setq ispell-program-name "hunspell"
        ispell-really-hunspell t
        ispell-dictionary "nb_NO"
        ispell-personal-dictionary "~/.hunspell_nb_NO"))

(defun rb/flyspell-target-file-p (&optional file)
  "Returner ikke-nil hvis FILE skal ha flyspell."
  (member (downcase (or (file-name-extension (or file "")) ""))
          '("md" "tex" "txt")))

(defvar rb/flyspell-startup-complete nil
  "Ikke-nil når det er greit å aktivere flyspell automatisk.")

(defun rb/flyspell-enable-for-current-buffer ()
  "Aktiver flyspell kun når current buffer faktisk vises."
  (when (and buffer-file-name
             rb/flyspell-startup-complete
             (get-buffer-window (current-buffer) t)
             (rb/flyspell-target-file-p buffer-file-name)
             (not (bound-and-true-p flyspell-mode)))
    (flyspell-mode 1)))

(defun rb/flyspell-enable-for-frame (frame)
  "Aktiver flyspell for valgt buffer i FRAME når startup er ferdig."
  (when rb/flyspell-startup-complete
    (let ((window (frame-selected-window frame)))
      (when (window-live-p window)
        (with-current-buffer (window-buffer window)
          (rb/flyspell-enable-for-current-buffer))))))

(defun rb/flyspell-finish-startup ()
  "Tillat auto-flyspell etter oppstart."
  (setq rb/flyspell-startup-complete t))

(defun rb/desktop-restore-flyspell (_desktop-buffer-locals)
  "Hindre at `desktop' gjenoppretter `flyspell-mode' automatisk."
  nil)

(defun rb/desktop-restore-flyspell-babel (_desktop-buffer-locals)
  "Hindre at `desktop' gjenoppretter `flyspell-babel-mode' automatisk."
  nil)

(use-package flyspell
  :defer t)

(add-to-list 'desktop-minor-mode-handlers
             '(flyspell-mode . rb/desktop-restore-flyspell))
(add-to-list 'desktop-minor-mode-handlers
             '(flyspell-babel-mode . rb/desktop-restore-flyspell-babel))

(add-hook 'emacs-startup-hook
          (lambda ()
            (run-with-idle-timer 1.5 nil #'rb/flyspell-finish-startup)))

(add-hook 'window-buffer-change-functions #'rb/flyspell-enable-for-frame)

(provide 'init-editing)
;;; init-editing.el ends here
