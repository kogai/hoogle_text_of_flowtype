FROM ocaml/opam:alpine-3.6_ocaml-4.03.0

ADD . ~/hoogle_text_of_flowtype
WORKDIR ~/hoogle_text_of_flowtype

RUN make install && \
  ocamlfind query ounit && \
  make test
