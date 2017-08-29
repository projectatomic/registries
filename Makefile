GO_MD2MAN ?= /usr/bin/go-md2man
PREFIX ?= $(DESTDIR)/usr
LIBEXEC ?= ${PREFIX}/libexec
SYSCONFDIR ?= $(DESTDIR)/etc/sysconfig


.PHONY: all
all: python-build docs

.PHONY: python-build
python-build:
	$(PYTHON) setup.py build

MANPAGES_MD = $(wildcard docs/*.md)

docs/%.1: docs/%.1.md
	$(GO_MD2MAN) -in $< -out $@.tmp && touch $@.tmp && mv $@.tmp $@

.PHONY: docs
docs: $(MANPAGES_MD:%.md=%)


.PHONY: clean
clean:
	$(PYTHON) setup.py clean
	-rm -rf dist build *~ \#* *pyc .#* docs/*.1

.PHONY: test 


test:
	TEST=1 bats test/test.bats


