;;; let-mode.el --- Easily set and revert variables in mode enable/disable -*- lexical-binding: t; -*-

;; Copyright (C) 2015 Free Software Foundation, Inc.

;; Author: David Shepherd <davidshepherd7@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "24") (seq) (names "0.5.4"))
;; URL: https://github.com/davidshepherd7/let-mode

;;; Commentary:


;;; Code:

(require 'seq)
(require 'names)

;; namespacing using names.el:
;;;###autoload
(define-namespace let-mode-

;; Tell names that it's ok to expand things inside these threading macros.
:functionlike-macros (-->)

:autoload
(defun revertable-set (&rest args)
  "As set but return a closure to revert the change"
  (let* ((pairs (seq-partition args 2))
         (vars (seq-map #'car pairs))
         (values (seq-map #'cadr pairs)))
    (-revertable-set-helper vars values)))

:autoload
(defun revertable-set-local (&rest args)
  "As set but return a closure to revert the change"
  (let* ((pairs (seq-partition args 2))
         (vars (seq-map #'car pairs))
         (values (seq-map #'cadr pairs)))
    (-revertable-set-helper (seq-map #'make-local-variable vars) values)))

(defun -revertable-set-helper (vars values)
  (let ((initial-values (seq-mapn #'symbol-value vars))
        (revert-done nil))
    (seq-mapn #'set vars values)
    (lambda ()
      (when (not revert-done)
        "Revert the variable values set by revertable-set"
        (seq-mapn
         (lambda (var value initial)
           (when (equal (symbol-value var) value)
             (set var initial)))
         vars values initial-values))
      (setq revert-done t))))

) ; end of namespace


(provide 'let-mode)

;;; let-mode.el ends here
