.PHONY: test check

run:
	dune exec ./main/ui.exe

build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe
	@$(MAKE) bisect-clean

bisect: bisect-clean
	@DUNE_INSTRUMENT_WITH=bisect_ppx dune exec --profile=coverage --force ./test/main.exe
	@bisect-ppx-report html

bisect-clean:
	@rm -rf _coverage bisect*.coverage

clean: bisect-clean
	@dune clean