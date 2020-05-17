;;; nyrml.el --- Not Your Regular Mode Line          -*- lexical-binding: t; -*-

;; Author: @a13
;; Keywords: convenience
;; Package-Requires: ((emacs "25.1") (eros "0.1.0"))
;; Homepage: http://github.com/a13/nyrml
;; Version: 0.0.1
;;

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Show mode-line-like information in an overlay

;;; Code:

(require 'eros)

(defgroup nyrml nil
  "Show mode-line-like info in an overlay."
  :group 'mode-line)

;; I don't like the defaults, but have to start somewhere
(defcustom nyrml-format '("%b %l:%c")
  "Analogous to  `mode-line-format' or `header-line-format' , but controls the nyrml overlay."
  :type 'list
  :group 'nyrml)

(defcustom nyrml-prefix nil
  "Override `eros-eval-result-prefix'."
  :type 'string
  :group 'nyrml)

(defcustom nyrml-interval 2
  "Idle time in seconds."
  :type 'number
  :group 'nyrml)

(defvar nyrml--timer nil "Idle timer for updating nyrml.")

;;;###autoload
(defun nyrml-show ()
  "Show an overlay formatted with `nyrml-format'."
  (interactive)
  (unless (minibufferp)
    (let ((eros-eval-result-prefix (or nyrml-prefix eros-eval-result-prefix))
          ;; A hack to make timer work
          (this-command 'nyrml-show))
      (eros--make-result-overlay
          (format-mode-line nyrml-format)
        :where (point)
        :duration eros-eval-result-duration))))

;;;###autoload
(define-minor-mode nyrml-mode ()
  :group 'nyrml
  :global t
  :lighter nil
  (if nyrml-mode
      (setq nyrml--timer
            (run-with-idle-timer nyrml-interval t 'nyrml-show))
    (cancel-timer nyrml--timer)))

(provide 'nyrml)
;;; nyrml.el ends here
