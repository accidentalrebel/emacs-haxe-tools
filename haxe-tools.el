;;; haxe-tools.el --- Collection of code to help with Haxe development

;; Copyright (C) 2016 Juan Karlo Lidudine

;; Author: Juan Karlo Licudine <accidentalrebel@gmail.com>
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
(require 'f)
(require 's)
(require 'subr-x)
(require 'thingatpt)

;; Variable handler functions
;;
(defun haxe-tools-add-word-at-point-as-private-class-variable()
  "Gets the variable name at point and adds it as a class private variable.
After adding the class variable, it positions the point so that you can easily specify the type of the variable.
Use the command \"pop-global-mark\" afterwards to jump to the initial position."
  (interactive)
  (haxe-tools-add-string-as-private-class-variable (thing-at-point 'word))
  )

(defun haxe-tools-add-string-as-private-class-variable(stringToAdd)
  "Adds the given string and makes it into a private class variable.
After adding the class variable, it positions the point so that you can easily specify the type of the variable.
Use the command \"pop-global-mark\" afterwards to jump to the initial position."
  (set-mark-command nil)
  (deactivate-mark)
  (search-backward-regexp "class " nil t)
  (haxe-tools-determine-where-to-place-class-variable)
  (indent-for-tab-command)
  (insert (concat "var " stringToAdd " : ;"))
  (backward-char))

(defun haxe-tools-make-word-at-point-into-private-class-variable()
  "Converts the function parameter with the format \"varName\" and turns it into a class private variable of format \"_varName\".
Use the command \"pop-global-mark\" afterwards to jump to the initial position."
  (interactive)
  (haxe-tools-make-string-into-private-class-variable (thing-at-point 'word))
  )

(defun haxe-tools-make-string-into-private-class-variable(stringToAdd)
  "Converts the given string into a private class variable.
Use the command \"pop-global-mark\" afterwards to jump to the initial position."
  (set-mark-command nil)
  (deactivate-mark)
  (forward-line 2)
  (open-line 1)
  (beginning-of-line)
  (indent-for-tab-command)
  (insert (concat "_" stringToAdd " = " stringToAdd ";"))
  (back-to-indentation)
  (haxe-tools-add-string-as-private-class-variable (concat "_" stringToAdd)))

(defun haxe-tools-determine-where-to-place-class-variable()
  "Determines where to place the class variable."
  (let ((private-var-declaration-point (re-search-forward "^[[:space:]]var .*;" nil t))
        (public-var-declaration-point (re-search-forward "^[[:space:]]public var .*;" nil t)))
    ;; 1. If there are private variables already declared, place the point before the first private variable declaration
    ;; 2. Else if there are public variable declarations, place the point after the last public variable declaration
    ;; 3. Else, add it as the first line of the class
    (cond (private-var-declaration-point
           (beginning-of-line)
             (open-line 1))
            (public-var-declaration-point
             (while (re-search-forward "^[[:space:]]public var .*;" nil t))
             (open-line 2)
             (forward-line 2)
             (beginning-of-line)
             )
            (t
             (forward-line 2)
             (open-line 2)))
      ))

;; Pagkage handler functions
;;
(defun haxe-tools-get-current-buffer-package()
  "Gets the package of the current haxe-mode buffer. This is the line usually on the top of the page preceded by \"package\""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (re-search-forward "^[ \t]*package[ \t]+.+[ \t]*;" nil t)
    (beginning-of-line)
    (let ((line (thing-at-point 'line)))
      (when line
        (haxe-tools-extract-package-from-line line)))))

(defun haxe-tools-put-current-buffer-package-to-clipboard()
  "Gets the package of the current haxe-mode buffer and then puts it into the clipboard."
  (interactive)
  (kill-new (haxe-tools-get-current-buffer-package)))

(defun haxe-tools-extract-package-from-line(line)
  "Extracts the package from the given line. For example, for \"package haxe.util;\", \"haxe.util\" is returned."
  (let ((extracted (cadr (s-match "package \\\(.*\\\);"
                                  (string-trim line)))))
    (message "Extracted -> %s" extracted)
    extracted
    ))

(defun haxe-tools-add-package-line-for-current-buffer (project-root)
  "Add the package line to the top of the current buffer.

Uses the format \"package com.test.package;\".

PROJECT-ROOT - The root of the current project. This directory string
is stripped off from the current directory path of the current file.
I suggest that you use projectile-project-root for this if you have
projectile installed."
  (message "Project root is  %s" project-root)
  (let* ((current-directory (f-dirname buffer-file-name))
	 (path-from-root (replace-regexp-in-string project-root "" current-directory))
	 (package-line (replace-regexp-in-string "/" "." path-from-root))
	 )
    (goto-char (point-min))
    (open-line 1)
    (insert (concat "package " package-line ";"))
    )
  )

(provide 'haxe-tools)

;;; haxe-tools.el ends here
