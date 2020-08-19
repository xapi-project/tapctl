OPAM_PREFIX?=$(DESTDIR)$(shell opam config var prefix)
OPAM_LIBDIR?=$(DESTDIR)$(shell opam config var lib)

.PHONY: release build install uninstall clean test doc format lint stresstest

release:
	dune build @install --profile=release

build:
	dune build @install --profile=dev

install:
	dune install --prefix=$(OPAM_PREFIX) --libdir=$(OPAM_LIBDIR) -p xapi-tapctl
	dune install -p vhd-tool

uninstall:
	dune uninstall --prefix=$(OPAM_PREFIX) --libdir=$(OPAM_LIBDIR) -p xapi-tapctl
	dune uninstall -p vhdtool

clean:
	dune clean

test:
	dune runtest

lint:
	pycodestyle bin/nbd/*.py
	pylint --disable too-many-locals bin/nbd/get_nbd_extents.py
	pylint --disable fixme,too-many-arguments,too-many-instance-attributes bin/nbd/python_nbd_client.py

stresstest:
	dune build @stresstest --no-buffer --profile=release

# requires odoc
doc:
	dune build @doc -profile=release

format:
	dune build @fmt --auto-promote

.DEFAULT_GOAL := release
