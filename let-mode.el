;;; let-mode.el --- Automatically add spaces around operators -*- lexical-binding: t; -*-

;; Copyright (C) 2015 Free Software Foundation, Inc.

;; Author: David Shepherd <davidshepherd7@gmail.com>
;; Version: 0.1
;; Package-Requires:
;; URL: https://github.com/davidshepherd7/let-mode

;;; Commentary:


;;; Code:

(require 'dash)
(require 'names)

;; namespacing using names.el:
;;;###autoload
(define-namespace let-mode-

;; Tell names that it's ok to expand things inside these threading macros.
:functionlike-macros (-->)

(defun revertable-bind (var value)
  (let ((initial-value (symbol-value var)))
    (set var value)
    (lambda ()
      (when (equal (symbol-value var) value)
        (set var initial-value)))))


) ; end of namespace

(provide 'let-mode)

;;; let-mode.el ends here
