open Parser_flow

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
        Translate.declarations ocaml_ast, errors
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
