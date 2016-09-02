
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
    (should (equal test/lm-test-var 1))))

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
    (should (equal test/lm-test-var 10))))

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
