open Parser_flow

let rec fib = function
  | 0 -> 0
  | 1 -> 1
| n -> fib (n - 2) + fib (n - 1)

let () =
  let filename = Some (File_key.SourceFile "my-file.js") in
  let _ = try
    Some (jsx_pragma_expression "declare function foo(): string" filename)
  with
  | Parse_error.Error [] ->
    print_string "Empty";
    None
  | Parse_error.Error ((_, e)::_) ->
    print_endline "Parse error!!!";
    None
  in
      
  print_int @@ fib 10
