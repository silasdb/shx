TARGETS = shx.pc

all: ${TARGETS}

shx.pc: shx.pc.m4
	m4 -DPWD=${PWD} $> > $@.tmp
	mv $@.tmp $@

.PHONY: test
test:
	cd tests && PKG_CONFIG_PATH=${PWD} atf-run | atf-report

.PHONY: clean
clean:
	rm -f ${TARGETS}
