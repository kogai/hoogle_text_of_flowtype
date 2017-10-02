OCB_FLAGS = -use-ocamlfind -use-menhir -I src -pkgs 'sedlex,ounit,core,menhirlib,ppx_deriving.show' -tags thread
OCB = ocamlbuild $(OCB_FLAGS)

build:native byte

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

init:
	opam init -ya --comp=4.03.0
	eval `opam config env`

install:
	opam update
	opam install -y \
		merlin \
		core \
		ocamlfind \
		flow_parser \
		ounit
	opam user-setup install

clean:
	$(OCB) -clean