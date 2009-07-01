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
	./uzbl --uri http://www.uzbl.org --verbose

test-dev: uzbl
	XDG_DATA_HOME=./examples/data               XDG_CONFIG_HOME=./examples/config               ./uzbl --uri http://www.uzbl.org --verbose

test-share: uzbl
	XDG_DATA_HOME=/usr/share/uzbl/examples/data XDG_CONFIG_HOME=/usr/share/uzbl/examples/config ./uzbl --uri http://www.uzbl.org --verbose
	
clean:
	rm -f uzbl
	rm -f uzblctrl

install:
	install -d $(BINDIR)
	install -d $(DOCSDIR)
	install -d $(EXMPLSDIR)
	install -m755 uzbl $(BINDIR)/uzbl
	install -m755 uzblctrl $(BINDIR)/uzblctrl
	cp -rp docs     $(UZBLDATA)
	cp -rp config.h $(DOCSDIR)
	cp -rp examples $(UZBLDATA)
	install -m644 AUTHORS $(DOCSDIR)
	install -m644 README  $(DOCSDIR)

uninstall:
	rm -rf $(BINDIR)/uzbl
	rm -rf $(BINDIR)/uzblctrl
	rm -rf $(UZBLDATA)
