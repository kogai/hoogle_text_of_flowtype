PKGS = ounit,core,ppx_deriving.show,sedlex,yojson
CFLAGS = "-I $(abspath ./)/flow/_build/src/parser"
LFLAGS = "-I $(abspath ./)/flow/_build/src/parser parser_flow.cmxa" 

OCB_FLAGS = -use-ocamlfind -use-menhir -I src -pkgs $(PKGS) -cflags $(CFLAGS) -lflags $(LFLAGS)
OCB = ocamlbuild $(OCB_FLAGS)
MODULES = $(wildcard $(abspath ./)/flow/_build/src/**/*.cmx)
OBJECTS = $(patsubst %.ml,%.cmxa,$(MODULES))

build:main.native build_flow

run:build
	./main.native 

test:
	$(OCB) main_test.native
	./main_test.native

main.native:
	$(OCB) main.native

main.byte:build_flow
	$(OCB) main.byte

debug:build
	$(OCB) -tag debug main.byte

build_flow:
	./scripts/flow_parser
	# ./scripts/flow

init:
	opam init -ya --comp=4.03.0
	eval `opam config env`

install:
	opam update
	opam install -y \
		ocamlfind \
		merlin \
		core \
		ounit \
		yojson \
		ppx_deriving \
		sedlex \
		ounit

setup:
	opam user-setup install -y

clean:
	$(OCB) -clean
