mkfile_path := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

prefix=/usr/local

install:
	ln -fs $(mkfile_path)/bin/tidal $(prefix)/bin
	ln -fs $(mkfile_path)/bin/tidalvim $(prefix)/bin

uninstall:
	rm -f $(prefix)/bin/tidal $(prefix)/bin/tidalvim

.PHONY: install uninstall
