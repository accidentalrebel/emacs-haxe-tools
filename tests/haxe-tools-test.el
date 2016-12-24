;;; haxe-tools-test.el --- Tests for haxe-tools.el

;; Copyright (C) 2016 Juan Karlo Lidudine

;;; Commentary:

;;; Code:

(require 'ert)

(ert-deftest t-haxe-tools-add-string-as-private-class-variable()
  (with-temp-buffer
    (insert "class MyClass\n")
    (insert "{\n")
    (insert "function func()\n")
    (insert "{\n")
    (insert "var _varName;\n")
    (insert "}")
    (haxe-tools-add-string-as-private-class-variable "_varName")
    (should
     (equal
      (buffer-string)
      (concat
       "class MyClass\n"
       "{\n"
       "        var _varName : ;\n\n"
       "function func()\n"
       "{\n"
       "var _varName;\n"
       "}")))))

(ert-deftest t-haxe-tools-make-string-into-private-class-variable()
  (with-temp-buffer
    (insert "class MyClass\n")
    (insert "{\n")
    (insert "function func(varName : Type)\n")
    (insert "{\n")
    (insert "Test\n")
    (insert "}")
    (forward-line -3)
    (haxe-tools-make-string-into-private-class-variable "varName")
    (should
     (equal
      (buffer-string)
      (concat
       "class MyClass\n"
       "{\n"
       "        var _varName : ;\n\n"
       "function func(varName : Type)\n"
       "{\n"
       "_varName = varName;\n"
       "Test\n"
       "}")))))

(ert-deftest t-haxe-tools-get-current-buffer-package-name()
  ;; Initial test
  (with-temp-buffer
    (insert "package test.mypackage;\n")
    (should (equal
             (haxe-tools-get-current-buffer-package-name) "test.mypackage")))

  ;; With a leading whitespace
  (with-temp-buffer
    (insert " package test.mypackage;\n")
    (should (equal
             (haxe-tools-get-current-buffer-package-name) "test.mypackage")))

  ;; With a multiple levels
  (with-temp-buffer
    (insert "package test.test2.test3.mypackage;\n")
    (should (equal
             (haxe-tools-get-current-buffer-package-name) "test.test2.test3.mypackage")))

  ;; With a package and import lines
  (with-temp-buffer
    (insert "package test.mypackage;\n")
    (insert "\n")
    (insert "import haxe.EnumTools;\n")
    (should (equal
             (haxe-tools-get-current-buffer-package-name) "test.mypackage")))

  ;; With blank spaces before the package line
  (with-temp-buffer
    (insert "\n")
    (insert "\n")
    (insert "package test.mypackage;\n")
    (insert "\n")
    (insert "import haxe.EnumTools;\n")
    (should (equal
             (haxe-tools-get-current-buffer-package-name) "test.mypackage")))

  ;; With the import statement before the package
  (with-temp-buffer
    (insert "import haxe.EnumTools;\n")
    (insert "\n")
    (insert "package test.mypackage;\n")
    (should (equal
             (haxe-tools-get-current-buffer-package-name) "test.mypackage")))
  )

(ert-deftest t-haxe-tools-put-current-buffer-package-name-to-clipboard()
  (with-temp-buffer
    (insert "package test.mypackage;\n")
    (insert "\n")
    (insert "import haxe.EnumTools;\n")
    (haxe-tools-put-current-buffer-package-name-to-clipboard)
    (should (equal
             (current-kill 0 1) "test.mypackage"))))

;;; haxe-tools-test.el ends here
