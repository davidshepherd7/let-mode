(require 'f)

(defvar let-mode-test-path
  (f-dirname (f-this-file)))

(defvar let-mode-code-path
  (f-parent let-mode-test-path))

(require 'let-mode (f-expand "let-mode.el" let-mode-code-path))
