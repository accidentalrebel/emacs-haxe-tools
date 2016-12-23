;;; haxe-tools.el --- Collection of code to help with haxe development

;;; Commentary:

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
