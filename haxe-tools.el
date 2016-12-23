;;; haxe-tools.el --- Collection of code to help with Haxe development

;; Copyright (C) 2016 Juan Karlo Lidudine

;; Author: Juan Karlo Licudine <karlo@accidentalrebel.com>
;; URL: http://www.github.com/accidentalrebel/emacs-haxe-tools
;; Package-Version: 20161223.01
;; Version: 0.1.0
;; Keywords: convenience, tools
;; Package-Requires: ((emacs "24.4") (s "1.10.0"))

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Collection of code to help with Haxe development on Emacs.

;; Usage:

;; (require 'haxe-tools) ;; unless installed as a package

;;; License:

;; This program is free software; you can redistributfe it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(require 's)
(require 'subr-x)

(defun haxe-tools-get-current-buffer-package-name()
  "Gets the package of the current haxe-mode buffer. This is the line usually on the top of the page preceded by \"package\""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (re-search-forward "^[ \t]*package[ \t]+.+[ \t]*;" nil t)
    (beginning-of-line)
    (let ((line (thing-at-point 'line)))
      (when line
        (haxe-tools-extract-package-from-line line)))))

(defun haxe-tools-put-current-buffer-package-name-to-clipboard()
  "Gets the package of the current haxe-mode buffer and then puts it into the clipboard."
  (interactive)
  (kill-new (haxe-tools-get-current-buffer-package-name)))

(defun haxe-tools-extract-package-from-line(line)
  "Extracts the package name from the given line. For example, for \"package haxe.util\", \"haxe.util\" is returned."
  (cadr (s-match "package \\\(.*\\\);"
                 (string-trim line))))

(provide 'haxe-tools)

;;; haxe-tools.el ends here
