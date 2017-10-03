OCB_FLAGS = -use-ocamlfind -use-menhir -I src -pkgs 'ounit,core,ppx_deriving.show,sedlex' -tags thread -cflags "-I /Users/kogaishinichi/hoogle_text_of_flowtype/flow/_build/src/parser" -lflags "-I /Users/kogaishinichi/hoogle_text_of_flowtype/flow/_build/src/parser parser_flow.cmxa"
OCB = ocamlbuild $(OCB_FLAGS)

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
	./scripts/flow

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
