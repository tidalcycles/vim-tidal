mkfile_path := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

bin=bin/tidalvim
prefix=/usr/local

install:
	ln -s $(mkfile_path)/$(bin) $(prefix)/bin

uninstall:
	rm $(prefix)/bin/tidalvim

.PHONY: install uninstall
