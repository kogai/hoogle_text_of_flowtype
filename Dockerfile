FROM ocaml/opam

ADD . ~/hoogle_text_of_flowtype
WORKDIR ~/hoogle_text_of_flowtype

RUN sudo make install && \
  ocamlfind query ounit && \
  make test
