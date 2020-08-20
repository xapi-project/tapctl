.PHONY: release build install uninstall clean test doc format lint stresstest

release:
	dune build @install --profile=release

build:
	dune build @install --profile=dev

install:
	mkdir -p $(ETCDIR)
	mkdir -p $(LIBEXECDIR)
	mkdir -p $(BINDIR)
	mkdir -p $(OPT_XS_LIBEXECDIR)
	mkdir -p $(OCAML_DIR)/lib
	mkdir -p $(OCAML_DIR)/doc
	# lib
	dune install --prefix=$(OCAML_DIR) xapi-tapctl
	# tools (ocaml)
	install -m 755 _build/install/default/bin/sparse_dd $(LIBEXECDIR)/sparse_dd
	install -m 755 _build/install/default/bin/vhd-tool $(BINDIR)/vhd-tool
	install -m 755 _build/install/default/bin/get_vhd_vsize $(LIBEXECDIR)/get_vhd_vsize
	install -m 644 bin/vhd/sparse_dd.conf $(ETCDIR)/sparse_dd.conf
	# tools (python)
	# we compile optimized pyc and pyo files
	python -m compileall bin/nbd/
	python -O -m compileall bin/nbd/
	install -m 755 bin/nbd/get_nbd_extents.py* $(OPT_XS_LIBEXECDIR)
	install -m 644 bin/nbd/python_nbd_client.py* $(OPT_XS_LIBEXECDIR)

clean:
	dune clean

test:
	printf "\n\n\nNO TESTS\n\n\n"

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
