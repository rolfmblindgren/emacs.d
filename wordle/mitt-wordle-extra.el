;;; mitt-wordle-extra.el --- Ekstrafunksjoner -*- lexical-binding: t; -*-
;;
;;; Code:

(defun mitt-wordle-random-tip ()
  "Returner et tilfeldig tips for Wordle."
  (nth (random 3)
       '("Ikke glem dobbelbokstaver."
         "Prøv å teste vokaler tidlig."
         "Unngå E som start hvis du vil ha utfordring.")))

(provide 'mitt-wordle-extra)
;;; mitt-wordle-extra.el ends here
