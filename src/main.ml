open Parser_flow

let () =
  let filename = Some (File_key.SourceFile "my-file.js") in
  let _ = try
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
  ()
