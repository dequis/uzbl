LIBS      := gtk+-2.0 webkit-1.0 gthread-2.0 libsoup-2.4
ARCH      := $(shell uname -m)
COMMIT    := $(shell git log | head -n1 | sed "s/.* //")
DEBUG     := -ggdb -Wall -W -DG_ERRORCHECK_MUTEXES

CFLAGS    := $(shell pkg-config --cflags $(LIBS)) $(DEBUG) -DARCH="\"$(ARCH)\"" -DCOMMIT="\"$(COMMIT)\"" -std=c99
LDFLAGS   := $(shell pkg-config --libs $(LIBS)) $(LDFLAGS)

PREFIX    ?= $(DESTDIR)/usr
BINDIR    ?= $(PREFIX)/bin
UZBLDATA  ?= $(PREFIX)/share/uzbl
DOCSDIR   ?= $(PREFIX)/share/uzbl/docs
EXMPLSDIR ?= $(PREFIX)/share/uzbl/examples

all: uzbl uzblctrl

uzbl: uzbl.c uzbl.h config.h

%: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $<

test: uzbl
	./uzbl --uri http://www.uzbl.org

test-config: uzbl
	./uzbl --uri http://www.uzbl.org < examples/configs/sampleconfig-dev

test-config-real: uzbl
	./uzbl --uri http://www.uzbl.org < $(EXMPLSDIR)/configs/sampleconfig
	
clean:
	rm -f uzbl
	rm -f uzblctrl

install:
	install -d $(PREFIX)/bin
	install -d $(PREFIX)/share/uzbl/docs
	install -d $(PREFIX)/share/uzbl/examples
	install -m755 uzbl $(PREFIX)/bin/uzbl
	install -m755 uzblctrl $(PREFIX)/bin/uzblctrl
	cp -rp docs     $(PREFIX)/share/uzbl/
	cp -rp config.h $(PREFIX)/share/uzbl/docs/
	cp -rp examples $(PREFIX)/share/uzbl/
	install -m644 AUTHORS $(PREFIX)/share/uzbl/docs
	install -m644 README  $(PREFIX)/share/uzbl/docs

uninstall:
	rm -rf $(BINDIR)/uzbl
	rm -rf $(BINDIR)/uzblctrl
	rm -rf $(UZBLDATA)
