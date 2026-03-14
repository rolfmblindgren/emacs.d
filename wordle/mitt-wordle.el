;;; mitt-wordle.el --- Simple Wordle tracker -*- lexical-binding: t; -*-
;;
;; Author: Ditt Navn <epost@adresse>
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Homepage: https://github.com/brukernavn/wordle
;; Keywords: games, convenience
;;
;;; Commentary:
;; Dette er en enkel Emacs-pakke for å leke med Wordle-statistikk.
;; Du kan utvide den med loggføring, analyse, osv.
;;
;;; Code:

;;;###autoload
(defun mitt-wordle-hello ()
  "En liten testkommando."
  (interactive)
  (message "Mitt Wordle fungerer!"))

(provide 'mitt-wordle)
;;; mitt-wordle.el ends here
