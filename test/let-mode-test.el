
(ert-deftest revertable-bind-normal-case ()
  ""
  (let ((test/lm-test-var 1)
        (test/lm-test-unbind nil))
    ;; Init
    (should (equal test/lm-test-var 1))

    ;; Set
    (setq test/lm-test-unbind (let-mode-revertable-bind 'test/lm-test-var 2))
    (should (equal test/lm-test-var 2))

    ;; Revert
    (funcall test/lm-test-unbind)
    (should (equal test/lm-test-var 1))))

(ert-deftest revertable-bind-set-outside ()
  ""
  (let ((test/lm-test-var 1)
        (test/lm-test-unbind nil))
    ;; Set
    (setq test/lm-test-unbind (let-mode-revertable-bind 'test/lm-test-var 2))

    ;; Something else sets the variable
    (setq test/lm-test-var 10)

    ;; Revert should do nothing
    (funcall test/lm-test-unbind)
    (should (equal test/lm-test-var 10))))
