
(ert-deftest revertable-set-normal-case ()
  ""
  (let ((test/lm-test-var 1)
        (test/lm-test-unset nil))
    ;; Init
    (should (equal test/lm-test-var 1))

    ;; Set
    (setq test/lm-test-unset (let-mode-revertable-set 'test/lm-test-var 2))
    (should (equal test/lm-test-var 2))

    ;; Revert
    (funcall test/lm-test-unset)
    (should (equal test/lm-test-var 1))

    ;; Ignore multiple calls to revert
    (setq test/lm-test-var 2)
    (funcall test/lm-test-unset)
    (should (equal test/lm-test-var 2))
    ))


(ert-deftest revertable-set-set-outside ()
  ""
  (let ((test/lm-test-var 1)
        (test/lm-test-unset nil))
    ;; Set
    (setq test/lm-test-unset (let-mode-revertable-set 'test/lm-test-var 2))

    ;; Something else sets the variable
    (setq test/lm-test-var 10)

    ;; Revert should do nothing
    (funcall test/lm-test-unset)
    (should (equal test/lm-test-var 10))

    ;; Ignore multiple calls to revert
    (setq test/lm-test-var 2)
    (funcall test/lm-test-unset)
    (should (equal test/lm-test-var 2))))


(ert-deftest revertable-setq-normal-case ()
  ""
  (let ((test/lm-test-var 1)
        (test/lm-test-unset nil))
    ;; Set
    (setq test/lm-test-unset (let-mode-revertable-setq test/lm-test-var 2))
    (should (equal test/lm-test-var 2))

    ;; Revert
    (funcall test/lm-test-unset)
    (should (equal test/lm-test-var 1))))


(ert-deftest revertable-setq-multiple ()
  ""
  (let ((test/lm-test-var 1)
        (test/lm-test-another "a")
        (test/lm-test-unset nil))
    ;; Set
    (setq test/lm-test-unset (let-mode-revertable-setq test/lm-test-var 2
                                                       test/lm-test-another "b"))
    (should (equal test/lm-test-var 2))
    (should (equal test/lm-test-another "b"))

    ;; Revert
    (funcall test/lm-test-unset)
    (should (equal test/lm-test-var 1))
    (should (equal test/lm-test-another "a"))
    ))

(ert-deftest revertable-setq-local ()
  "setq-local should work as setq but only affect the current buffer"
  (defvar test/lm-test-var 1)
  (defvar test/lm-test-var-2 "a")
  (defvar test/lm-test-unset nil)

  (with-temp-buffer
    (setq test/lm-test-unset
          (let-mode-revertable-setq-local test/lm-test-var 2
                                          test/lm-test-var-2 "b"))
    (should (equal test/lm-test-var 2))
    (should (equal test/lm-test-var-2 "b"))

    ;; Other buffer is unaffected
    (with-temp-buffer
      (should (equal test/lm-test-var 1))
      (should (equal test/lm-test-var-2 "a")))

    ;; Revert
    (funcall test/lm-test-unset)
    (should (equal test/lm-test-var 1))
    (should (equal test/lm-test-var-2 "a"))))


(ert-deftest actual-minor-mode ()
  ""
  (setq indent-tabs-mode nil)
  (require 'cc-mode)
  (require 'sgml-mode)
  (require 'js)

  (defvar tabs-mode-reverter
    #'ignore
    "Variable to hold function to revert changes made by tabs-mode")

  (define-minor-mode tabs-mode
    "Test case for let-mode"
    :global nil
    (if tabs-mode
        (setq tabs-mode-reverter
              (let-mode-revertable-setq
               indent-tabs-mode t
               tab-width 4
               c-basic-offset 4
               sgml-basic-offset 4
               js-indent-level 4
               ;; etc.
               ))
      ;; else
      (when tabs-mode-reverter
        (funcall tabs-mode-reverter))))


  (should (not indent-tabs-mode))
  (should (equal tab-width 8))

  (tabs-mode 1)
  (should indent-tabs-mode)
  (should (equal tab-width 4))

  (tabs-mode 0)
  (should (not indent-tabs-mode))
  (should (equal tab-width 8))

  )
