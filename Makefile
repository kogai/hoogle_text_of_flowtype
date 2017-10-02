OCB_FLAGS = -use-ocamlfind -use-menhir -I src -I flow/src/parser -pkgs 'ounit,core,ppx_deriving.show,flow_parser' -tags thread
OCB = ocamlbuild $(OCB_FLAGS)

build:flow_parser native byte

run:build
	./main.native 

# test:
# 	$(OCB) main_test.native
# 	./main_test.native

native:
	$(OCB) main.native

byte:
	$(OCB) main.byte

debug:
	$(OCB) -tag debug main.byte

flow_parser:
	./scripts/flow_parser

init:
	opam init -ya --comp=4.03.0
	eval `opam config env`

install:
	opam update
	opam install -y \
		merlin \
		core \
		ocamlfind \
		ounit
	opam user-setup install

clean:
	$(OCB) -clean
