EMACS = emacs
CASK ?= cask

build :
	cask exec $(EMACS) -Q --batch --eval             \
	    "(progn                                \
	      (setq byte-compile-error-on-warn t)  \
	      (batch-byte-compile))" let-mode.el

unit:
	${CASK} exec ert-runner

e2e:
	${CASK} exec ecukes

test: build unit e2e
