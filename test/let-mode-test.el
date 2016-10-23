
(ert-deftest revertable-set-normal-case ()
  ""
  (let ((lm/foo 1)
        (lm/revert-fn nil))
    ;; Init
    (should (equal lm/foo 1))

    ;; Set
    (setq lm/revert-fn (let-mode-revertable-set 'lm/foo 2))
    (should (equal lm/foo 2))

    ;; Revert
    (funcall lm/revert-fn)
    (should (equal lm/foo 1))

    ;; Ignore multiple calls to revert
    (setq lm/foo 2)
    (funcall lm/revert-fn)
    (should (equal lm/foo 2))
    ))


(ert-deftest revertable-set-set-outside ()
  ""
  (let ((lm/foo 1)
        (lm/revert-fn nil))
    ;; Set
    (setq lm/revert-fn (let-mode-revertable-set 'lm/foo 2))

    ;; Something else sets the variable
    (setq lm/foo 10)

    ;; Revert should do nothing
    (funcall lm/revert-fn)
    (should (equal lm/foo 10))

    ;; Ignore multiple calls to revert
    (setq lm/foo 2)
    (funcall lm/revert-fn)
    (should (equal lm/foo 2))))


(ert-deftest revertable-set-multiple ()
  ""
  (let ((lm/foo 1)
        (lm/bar "a")
        (lm/revert-fn nil))
    ;; Set
    (setq lm/revert-fn (let-mode-revertable-set 'lm/foo 2
                                                'lm/bar "b"))
    (should (equal lm/foo 2))
    (should (equal lm/bar "b"))

    ;; Revert
    (funcall lm/revert-fn)
    (should (equal lm/foo 1))
    (should (equal lm/bar "a"))
    ))

(ert-deftest revertable-set-local ()
  "set-local should work as set but only affect the current buffer"
  (defvar lm/foo 1)
  (defvar lm/foo-2 "a")
  (defvar lm/revert-fn #'ignore)

  (with-temp-buffer
    (setq lm/revert-fn
          (let-mode-revertable-set-local 'lm/foo 2
                                         'lm/foo-2 "b"))
    (should (equal lm/foo 2))
    (should (equal lm/foo-2 "b"))

    ;; Other buffer is unaffected
    (with-temp-buffer
      (should (equal lm/foo 1))
      (should (equal lm/foo-2 "a")))

    ;; Revert
    (funcall lm/revert-fn)
    (should (equal lm/foo 1))
    (should (equal lm/foo-2 "a"))))


(ert-deftest actual-minor-mode ()
  ""
  (setq indent-tabs-mode nil)
  (require 'cc-mode)
  (require 'sgml-mode)
  (require 'js)

  (defvar tabs-mode-revert-fn
    #'ignore
    "Variable to hold function to revert changes made by tabs-mode")

  (define-minor-mode tabs-mode
    "Test case for let-mode"
    :global nil
    (if tabs-mode
        (setq tabs-mode-revert-fn
              (let-mode-revertable-set-local
               'indent-tabs-mode t
               'tab-width 4
               'c-basic-offset 4
               'sgml-basic-offset 4
               'js-indent-level 4
               ;; etc.
               ))
      ;; else
      (funcall tabs-mode-revert-fn)))


  (should (not indent-tabs-mode))
  (should (equal tab-width 8))

  (tabs-mode 1)
  (should indent-tabs-mode)
  (should (equal tab-width 4))

  (tabs-mode 0)
  (should (not indent-tabs-mode))
  (should (equal tab-width 8))

  )
