open Parser_flow

(* let parse content options = *)
(* let options =
  if options = Js.undefined
  then Js.Unsafe.obj [||]
  else options
in
let content = Js.to_string content in
let parse_options = Some (parse_options options) in
let (ocaml_ast, errors) = Parser_flow.program ~fail:false ~parse_options content in
JsTranslator.translation_errors := [];
let module Translate = Estree_translator.Translate (JsTranslator) (struct
  let include_comments = true
  let include_locs = true
end) in
let ret = Translate.program ocaml_ast in
let translation_errors = !JsTranslator.translation_errors in
Js.Unsafe.set ret "errors" (Translate.errors (errors @ translation_errors));
ret *)

let () =
  let content = "const foo: string = \"my-string\";" in
  let filename = Some (File_key.SourceFile "my-file.js") in
  let (ast, errors) = program_file content filename in

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
