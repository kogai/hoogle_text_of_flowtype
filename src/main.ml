open Parser_flow

module Translate = Estree_translator.Translate (struct
  open Yojson
  type t = json

  let string x = `String x
  let bool x = `Bool x
  let obj props = `Assoc (Array.to_list props)
  let array arr = `List (Array.to_list arr)
  let number x = `Float x
  let null = `Null
  let regexp _loc _pattern _flags = `Null
end) (struct
  let include_comments = true
  let include_locs = true
end) 

let rec print_error = function
  | [] -> print_endline "No error";
  | (_, e)::es ->
    print_endline @@ Parse_error.PP.error e;
    print_error es

let () =
  let content = "const foo: string = \"my-string;\"" in
  let filename = Some (File_key.SourceFile "my-file.js") in
  let (ocaml_ast, errors) = program_file content filename in
  
  (* let result =
    try
      let (translated_ast, errors) =
        let (ocaml_ast, errors) = program_file content filename in
        Translate.program ocaml_ast, errors
      in
      (translated_ast, errors)
    with Parse_error.Error l ->
      exit (0)
      (* Yojson.`Assoc ["errors", Translate.errors l] *)
  in *)

  prerr_newline ();
  print_error errors;
  prerr_newline ();

  ()
