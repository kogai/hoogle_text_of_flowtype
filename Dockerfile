FROM ocaml/opam

ADD . ~/hoogle_text_of_flowtype
WORKDIR ~/hoogle_text_of_flowtype

RUN make init && \
  make install && \
  git submodule update -i

RUN eval $(opam config env) && \
  ocamlfind list && \
  ls -l ~/.opam/packages
# ocamlfind query ounit
