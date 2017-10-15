open Core
open Cmdliner


let () =
  Term.exit @@ Term.eval (Htof.Cmd.term, Term.info Htof.Cmd.name)
