;;; init-ai.el --- AI and repo-context helpers -*- lexical-binding: t; -*-

(require 'init-compat)
(require 'auth-source)
(require 'project)

(defun rb/repo-review ()
  (interactive)
  (gptel-send
   "Lag en senior code review av repoet i kontekst.
Gi:
1. arkitekturproblemer
2. skjulte bugs
3. PrestaShop-antipatterns
4. performance-risiko
5. neste beste refactor."))

(defun rb/authinfo-secret (host &optional user)
  "Hent passord fra ~/.authinfo(.gpg) for HOST."
  (let* ((match (car (auth-source-search
                      :host host
                      :user (or user "apikey")
                      :require '(:secret)
                      :max 1)))
         (secret (plist-get match :secret)))
    (cond
     ((functionp secret) (funcall secret))
     ((stringp secret) secret)
     (t nil))))

(use-package gptel
  :ensure t
  :init
  (setq gptel-default-mode 'markdown-mode
        gptel-use-header-line t
        gptel-system-message "Svar på norsk med mindre jeg ber om noe annet.")
  :config
  (setq gptel-backend
        (gptel-make-anthropic "Claude"
          :key (or (getenv "ANTHROPIC_API_KEY")
                   (rb/authinfo-secret "api.anthropic.com"))
          :stream t))
  (setq gptel-model "claude-sonnet-4-6")

  (defun rb/gptel-claude ()
    "Åpne/byt til standard Claude-buffer."
    (interactive)
    (gptel "Claude" nil nil))

  (defun rb/gptel-send-region (beg end)
    "Send markert region til gptel."
    (interactive "r")
    (unless (use-region-p)
      (user-error "Ingen markering"))
    (let ((txt (buffer-substring-no-properties beg end)))
      (rb/gptel-claude)
      (goto-char (point-max))
      (insert txt)
      (gptel-send)))

  (global-set-key (kbd "C-c g g") #'rb/gptel-claude)
  (global-set-key (kbd "C-c g m") #'gptel-menu)
  (global-set-key (kbd "C-c g s") #'gptel-send)
  (global-set-key (kbd "C-c g r") #'rb/gptel-send-region))

(defgroup rb-gptel nil
  "Repo-kontekst til gptel."
  :group 'tools)

(defcustom rb/gptel-repo-max-bytes (* 700 1024)
  "Maks antall bytes som legges i repo-kontekstbufferen."
  :type 'integer)

(defcustom rb/gptel-repo-exclude-regexp
  (rx (or
       "/node_modules/" "/vendor/" "/dist/" "/build/" "/.next/" "/.cache/"
       "/coverage/" "/target/" "/.git/" "/.idea/" "/.vscode/"
       ".min.js" ".min.css"
       ".lock" "package-lock.json" "pnpm-lock.yaml" "yarn.lock"
       ".png" ".jpg" ".jpeg" ".gif" ".webp" ".pdf" ".zip" ".gz"))
  "Regexp for filer/mapper som ikke skal med i repo-kontekst."
  :type 'regexp)

(defun rb/project-root ()
  "Finn prosjektrot (project.el), ellers vc-root, ellers default-directory."
  (or (when-let ((pr (project-current nil)))
        (project-root pr))
      (when (fboundp 'vc-root-dir)
        (vc-root-dir))
      default-directory))

(defun rb/git-ls-files (root)
  "Returner liste over git-trackede filer under ROOT."
  (let ((default-directory root))
    (process-lines "git" "ls-files" "-z")))

(defun rb/file-bytes (path)
  (file-attribute-size (file-attributes path)))

(defun rb/insert-file-snippet (file root)
  "Sett inn FILE (relativ sti) med header + innhold."
  (let ((abs (expand-file-name file root)))
    (insert (format "\n\n### %s\n\n" file))
    (insert-file-contents abs nil nil nil)
    (unless (bolp)
      (insert "\n"))))

(defun rb/make-repo-context-buffer (&optional root)
  "Bygg/oppdater *repo-context* fra repoet."
  (interactive)
  (let* ((root (file-name-as-directory (or root (rb/project-root))))
         (buf (get-buffer-create "*repo-context*"))
         (files (rb/git-ls-files root))
         (total 0))
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (erase-buffer)
      (insert (format "# Repo context\n\nRoot: %s\nGenerated: %s\n"
                      root
                      (current-time-string)))
      (dolist (f files)
        (when (and (stringp f)
                   (not (string-match-p rb/gptel-repo-exclude-regexp f)))
          (let* ((abs (expand-file-name f root))
                 (sz (rb/file-bytes abs)))
            (when (< sz (* 200 1024))
              (when (< total rb/gptel-repo-max-bytes)
                (rb/insert-file-snippet f root)
                (setq total (+ total sz)))))))
      (goto-char (point-min))
      (setq buffer-read-only t)
      (current-buffer))))

(global-set-key (kbd "C-c r c") #'rb/make-repo-context-buffer)

(provide 'init-ai)
;;; init-ai.el ends here
