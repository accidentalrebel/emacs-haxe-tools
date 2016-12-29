# Emacs Haxe Tools
Collection of code to help with Haxe development on Emacs

# Introduction
I've been using Emacs as my environment for Haxe development for quite a while now and have made a number of convenience functions to help me with my work. 

This library should be considered as a collection of random tools that may or may not be helpful. Most of the functions here were added because I myself need them in my work so do not expect this to be comprehensive, at least for now.

## Functions
Function | Use 
---------|----
`haxe-tools-add-word-at-point-as-private-class-variable` | Gets the variable name at point and adds it as a class private variable. After adding the class variable, it positions the point so that you can easily specify the type of the variable.
`haxe-tools-make-word-at-point-into-private-class-variable` | Converts the function parameter with the format "varName" and turns it into a class private variable of format "_varName"
`haxe-tools-get-current-buffer-package` | Gets the package of the current haxe-mode buffer. This is the line usually on the top of the page preceded by "package"
`haxe-tools-put-current-buffer-package-to-clipboard` | Gets the package of the current haxe-mode buffer and then puts it into the clipboard.
More to be added! | 

# Also check out

* [Emacs Haxe Imports](https://github.com/accidentalrebel/emacs-haxe-imports) - An emacs package I made which contains code dealing with Haxe imports based on [java-imports](http://www.github.com/dakrone/emacs-java-imports) by Matthew Lee Hinman.

# Contributions
I am open to suggestions for any features that might be useful. Pull requests are also very welcome!
