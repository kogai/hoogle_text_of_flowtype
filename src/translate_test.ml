open Core
open OUnit2
open Parser_flow
open Translate

let filename = Some (File_key.SourceFile "my-file.js")

let specs = [
  "be able to derive tupple from list" >:: (fun ctx ->
      let actual = Translate.tupple_str_of_list ["string";"number";] in
      assert_equal actual "(string, number)"
    );
  "be able to parse function declaration" >:: (fun ctx ->
      let actual = 
        "fixture/translate_function_actual.js"
        |> Utils.open_file
        |> (fun (content, filename) -> program_file content filename)
        |> (fun (ocaml_ast, errors) -> Translate.declarations ocaml_ast, errors)
        |> (fun (xs, _) -> Option.value_exn (List.hd xs))
      in
      assert_equal actual "f ∷ String -> Float"
    );
  "be able to parse with multiple parameters" >:: (fun ctx ->
      let actual = 
        "fixture/translate_multiple_parameters.js"
        |> Utils.open_file
        |> (fun (content, filename) -> program_file content filename)
        |> (fun (ocaml_ast, errors) -> Translate.declarations ocaml_ast, errors)
        |> (fun (xs, _) -> Option.value_exn (List.hd xs))
      in
      assert_equal actual "f ∷ (String, Float) -> Bool"
    );
]
