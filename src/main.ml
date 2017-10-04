open Parser_flow

module Translate : (sig
  type t
  val program: Loc.t * Loc.t Ast.Statement.t list * (Loc.t * Ast.Comment.t') list -> t
  val errors: (Loc.t * Parse_error.t) list -> t
  val string_of_json : t -> string
end) = struct
  open Yojson
  type t = json

  let string x = `String x
  let bool x = `Bool x
  let obj props = `Assoc (Array.to_list props)
  let array arr = `List (Array.to_list arr)
  let number x = `Float x
  let null = `Null
  let regexp _loc _pattern _flags = `Null

  let program x = exit (1)
  let errors x = exit (1)
  let string_of_json x = exit (1)
end

let rec print_error = function
  | [] -> print_endline "No error";
  | (_, e)::es ->
    print_endline @@ Parse_error.PP.error e;
    print_error es

let () =
  let content = "const foo: string = \"my-string;\"" in
  let filename = Some (File_key.SourceFile "my-file.js") in
  let (ocaml_ast, errors) = program_file content filename in
  
  let (result, _) =
    try
      let (translated_ast, errors) =
        let (ocaml_ast, errors) = program_file content filename in
        Translate.program ocaml_ast, errors
      in
      (translated_ast, errors)
    with Parse_error.Error l ->
      prerr_newline ();
      print_error errors;
      prerr_newline ();
      exit (0)
  in

  print_endline @@ Translate.string_of_json result;
  ()
