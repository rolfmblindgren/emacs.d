;;; init-tex.el --- LaTeX and bibliography setup -*- lexical-binding: t; -*-

(require 'init-compat)

(require 'LaTeX-quote-hacks)

(defvar reftex-auto-view-crossref)

(defun rb/desktop-restore-reftex (_desktop-buffer-locals)
  "Gjenopprett `reftex-mode' uten å slå på auto-crossref."
  (let ((reftex-auto-view-crossref nil))
    (put 'reftex-auto-view-crossref 'initialized t)
    (when (fboundp 'reftex-mode)
      (reftex-mode 1))))

(defun resolve-jobname-to-actual-filename ()
  "Hvis dokumentet bruker \\jobname i \\addbibresource,
erstatt det med faktisk filnavn for RefTeX sin skyld."
  (when (and (buffer-file-name)
             (save-excursion
               (goto-char (point-min))
               (re-search-forward "\\\\addbibresource{\\\\jobname\\.bib}" nil t)))
    (let* ((basename (file-name-base (buffer-file-name)))
           (actual-bib (concat basename ".bib"))
           (tex-file (buffer-file-name))
           (bib-dir (file-name-directory tex-file))
           (bib-path (expand-file-name actual-bib bib-dir)))
      (if (file-exists-p bib-path)
          (progn
            (message "RefTeX hack: Mapper \\jobname.bib til %s" bib-path)
            (setq-local reftex-extra-bindings
                        (list (cons "\\jobname.bib" bib-path))))
        (message "Advarsel: Kunne ikke finne bib-fil for \\jobname (%s)"
                 bib-path)))))

(defun sync-bibinputs-with-texlive ()
  "Synkroniser Emacs sin BIBINPUTS med TeXLive sin via kpsewhich."
  (let ((bibpath (string-trim (shell-command-to-string "kpsewhich -show-path=bib"))))
    (setenv "BIBINPUTS" bibpath)))

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :hook ((LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . visual-line-mode))
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-engine 'xetex
        reftex-plug-into-AUCTeX t
        reftex-cite-format 'biblatex))

(use-package reftex
  :ensure nil
  :init
  (setq reftex-auto-view-crossref nil)
  (put 'reftex-auto-view-crossref 'initialized t)
  :after auctex
  :config
  (setq reftex-auto-view-crossref nil))

(add-to-list 'desktop-minor-mode-handlers
             '(reftex-mode . rb/desktop-restore-reftex))

(provide 'init-tex)
;;; init-tex.el ends here
