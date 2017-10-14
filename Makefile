NAME := main
TEST_NAME := $(NAME)_test
PKGS := ounit,core,ppx_deriving.show,sedlex,yojson

PARSER_NAME := parser_flow.cmxa
PARSER_DIR := $(abspath ./)/flow/_build/src/parser
CFLAGS := "-I $(PARSER_DIR)"
LFLAGS := "-I $(PARSER_DIR) $(PARSER_NAME)"
SRC_DIRS := "src flow/src/parser flow/src/third-party/wtf8"
SRC_FILES := $(shell find ./src -type f -name '*.ml')

OCB_FLAGS := -use-ocamlfind -use-menhir -Is $(SRC_DIRS) -pkgs $(PKGS)
OCB := ocamlbuild $(OCB_FLAGS)
MODULES = $(wildcard $(abspath ./)/flow/_build/src/**/*.cmx)
OBJECTS = $(patsubst %.ml,%.cmxa,$(MODULES))

all:$(NAME).native $(NAME).byte

$(NAME).native: $(PARSER_DIR)/$(PARSER_NAME) $(SRC_FILES)
	$(OCB) $(NAME).native

$(NAME).byte: $(PARSER_DIR)/$(PARSER_NAME) $(SRC_FILES)
	$(OCB) $(NAME).byte

.PHONY: native
native: $(NAME).native
	./$(NAME).native

.PHONY: byte
byte: $(NAME).byte
	./$(NAME).byte

$(PARSER_DIR)/$(PARSER_NAME):
	@cd flow/src/parser && \
	make

$(TEST_NAME).native: $(SRC_FILES)
	$(OCB) $(TEST_NAME).native

$(TEST_NAME).byte: $(SRC_FILES)
	$(OCB) $(TEST_NAME).byte

.PHONY: test
test: $(TEST_NAME).native $(TEST_NAME).byte
	./$(TEST_NAME).native
	./$(TEST_NAME).byte

.PHONY: init
init:
	opam init -ya --comp=4.03.0
	eval `opam config env`

.PHONY: install
install:
	opam update
	opam install -y \
		ocamlfind \
		merlin \
		core \
		yojson \
		ppx_deriving \
		sedlex \
		ounit

.PHONY: setup
setup:
	opam user-setup install -y

.PHONY: clean
clean:
	$(OCB) -clean
	@cd flow/src/parser \
	make clean
