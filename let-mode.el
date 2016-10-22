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
(defun revertable-set (var value)
  "As set but return a closure to revert the change"
  (-revertable-set-helper (list var) (list value)))

(defun -revertable-set-helper (vars values)
  (let ((initial-values (seq-mapn #'symbol-value vars))
        (revert-done nil))
    (seq-mapn #'set vars values)
    (lambda ()
      (when (not revert-done)
        "Revert the variable values set by revertable-set(q)"
        (seq-mapn
         (lambda (var value initial)
           (when (equal (symbol-value var) value)
             (set var initial)))
         vars values initial-values))
      (setq revert-done t))))

:autoload
(defmacro revertable-setq (&rest args)
  "As setq but return a closure to revert the changes"
  (let* ((pairs (seq-partition args 2))
         (vars (seq-map #'car pairs))
         (values (seq-map #'cadr pairs)))
    `(let-mode--revertable-set-helper ',vars ',values)))

:autoload
(defmacro revertable-setq-local (&rest args)
  "As setq-local but return a closure to revert the changes

Unlike setq-local this macro set any number of variables at once."
  (let* ((pairs (seq-partition args 2))
         (vars (seq-map #'car pairs))
         (values (seq-map #'cadr pairs)))
    `(progn
       (seq-map (lambda (v) (make-local-variable v)) ',vars)
       (let-mode--revertable-set-helper ',vars ',values))))



) ; end of namespace


(provide 'let-mode)

;;; let-mode.el ends here
