# Let mode

[![travis](https://travis-ci.org/davidshepherd7/let-mode.svg?branch=master)](https://travis-ci.org/davidshepherd7/let-mode) <!-- [![melpa](http://melpa.org/packages/let-mode-badge.svg)](http://melpa.org/#/let-mode)  -->[![GPLv3](http://img.shields.io/badge/license-GNU%20GPLv3-blue.svg)](https://github.com/davidshepherd7/let-mode/blob/master/LICENSE)

Create emacs minor modes which set variables when activated and unset them when deactivated.

# Usage

let-mode can be used to define a simple minor mode which temporarily sets a list
of variables to some values when the mode is enabled and reverts them on
disable.

For example here is a very simple local minor mode that sets up tabs for
indentation in various major modes:

    (defvar tabs-mode-revert-fn
      #'ignore
      "Variable to hold function to revert changes made by tabs-mode")

    (define-minor-mode tabs-mode
      "Test case for let-mode"
      :global nil
      (if tabs-mode
          (setq tabs-mode-revert-fn
                (let-mode-revertable-setq-local
                 indent-tabs-mode t
                 tab-width 4
                 c-basic-offset 4
                 sgml-basic-offset 4
                 js-indent-level 4
                 ;; etc.
                 ))
        ;; else
        (when tabs-mode-revert-fn
          (funcall tabs-mode-revert-fn))))

To instead create a global minor mode replace `let-mode-revertable-setq-local`
with `let-mode-revertable-setq`.


# Changelog

TODO
