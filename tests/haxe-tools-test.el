;;; haxe-tools-test.el --- Tests for haxe-tools.el

;;; Commentary:
;;; Code:
(require 'ert)

(ert-deftest t-haxe-tools-get-current-buffer-package-name()
  (with-temp-buffer
    (insert "package test.mypackage;\n")
    (insert "\n")
    (insert "import haxe.EnumTools;\n")
    (should (equal
             (haxe-tools-get-current-buffer-package-name) "test.mypackage"))))

(ert-deftest t-haxe-tools-put-current-buffer-package-name-to-clipboard()
  (with-temp-buffer
    (insert "package test.mypackage;\n")
    (insert "\n")
    (insert "import haxe.EnumTools;\n")
    (haxe-tools-put-current-buffer-package-name-to-clipboard)
    (should (equal
             (current-kill 0 1) "test.mypackage"))))

;;; haxe-tools-test.el ends here
