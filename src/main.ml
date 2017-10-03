open Parser_flow

let rec print_error = function
  | [] -> print_endline "No error";
  | (_, e)::es ->
    print_endline @@ Parse_error.PP.error e;
    print_error es

let () =
  let content = "const foo: string = \"my-string;" in
  let filename = Some (File_key.SourceFile "my-file.js") in
  let (ast, errors) = program_file content filename in
  
  prerr_newline ();
  print_error errors;
  prerr_newline ();

  (* (Hack.Hackfmt.Debug.Hackfmt_debug.debug) *)
  ()

  (* let _ = try
    let x = Some (jsx_pragma_expression "const foo: string = \"my-string\";" filename) in
    print_endline "Parsed!!!";
    x
  with
  | Parse_error.Error [] ->
    print_string "Empty";
    None
  | Parse_error.Error ((_, e)::_) ->
    print_endline "Parse error!!!";
    None
  in
  () *)
