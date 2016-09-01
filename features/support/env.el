(require 'f)

(defvar let-mode-support-path
  (f-dirname load-file-name))

(defvar let-mode-features-path
  (f-parent let-mode-support-path))

(defvar let-mode-root-path
  (f-parent let-mode-features-path))

(add-to-list 'load-path let-mode-root-path)

(require 'let-mode)
(require 'espuds)
(require 'ert)

(Setup
 ;; Before anything has run
 )

(Before
 ;; Before each scenario is run
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )
