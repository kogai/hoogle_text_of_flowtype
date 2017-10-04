PKGS = ounit,core,ppx_deriving.show,sedlex,yojson
CFLAGS = "-I $(abspath ./)/flow/_build/src/parser"
LFLAGS = "-I $(abspath ./)/flow/_build/src/parser parser_flow.cmxa" 

OCB_FLAGS = -use-ocamlfind -use-menhir -I src -pkgs $(PKGS) -cflags $(CFLAGS) -lflags $(LFLAGS)
OCB = ocamlbuild $(OCB_FLAGS) -verbose 0
MODULES = $(wildcard $(abspath ./)/flow/_build/src/**/*.cmx)
OBJECTS = $(patsubst %.ml,%.cmxa,$(MODULES))

build:native build_flow

run:build
	./main.native 

# test:
# 	$(OCB) main_test.native
# 	./main_test.native

native:
	$(OCB) main.native

byte:build_flow
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
		merlin \
		core \
		ocamlfind \
		ounit
	opam user-setup install

clean:
	$(OCB) -clean
