open Core
open OUnit2
open Parser_flow
open Translate

let get_result filename =
  filename
  |> Utils.open_file
  |> (fun (content, filename) -> program_file content filename)
  |> (fun (ocaml_ast, errors) -> Translate.declarations ocaml_ast, errors)
  |> (fun (xs, _) -> Option.value_exn (List.hd xs))

let specs = [
  "be able to derive tupple from list" >:: (fun ctx ->
      let actual = Translate.tupple_str_of_list ["string";"number";] in
      assert_equal actual "(string, number)"
    );
  "be able to parse function declaration" >:: (fun ctx ->
      let actual = get_result "fixture/translate_function_actual.js" in
      assert_equal actual "f ∷ String -> Float"
    );
  "be able to parse with multiple parameters" >:: (fun ctx ->
      let actual = get_result "fixture/translate_multiple_parameters.js" in
      assert_equal actual "f ∷ (String, Float) -> Bool"
    );
  "be able to parse with rest parameters" >:: (fun ctx ->
      let actual = get_result "fixture/translate_function_rest.js" in
      assert_equal actual "f ∷ (String, Float, [String]) -> IO ()"
    );
  "be able to parse with optional parameters" >:: (fun ctx ->
      let actual = get_result "fixture/optional.js" in
      print_endline actual;
      assert_equal actual "f ∷ Maybe String -> IO ()"
    );
]
