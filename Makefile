all: test

.PHONY: test
test:
	cd tests && atf-run | atf-report
