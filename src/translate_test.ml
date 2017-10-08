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

let translate_specs = List.map [
    ("fixture/translate_function_actual.js", "f ∷ String -> Float");
    ("fixture/translate_multiple_parameters.js", "f ∷ (String, Float) -> Bool");
    ("fixture/translate_function_rest.js", "f ∷ (String, Float, [String]) -> IO ()");
    ("fixture/optional.js", "f ∷ Maybe String -> IO ()");
    ("fixture/generics.js", "f ∷ t -> [t]");
    ("fixture/type_alias.js", "f ∷ AType -> BType");
    ("fixture/curried.js", "f ∷ String -> Float -> Bool");
    (* 
    Remained specs
    * bounded
    * JavaScript tupple (actually Array)
    *)
  ] (fun (filepath, expect) ->
    filepath >:: (fun ctx ->
        let actual = get_result filepath in
        (* print_endline actual; *)
        assert_equal actual expect
      );
  )

let specs = [
  "be able to derive tupple from list" >:: (fun ctx ->
      let actual = Translate.tupple_str_of_list ["string";"number";] in
      assert_equal actual "(string, number)"
    );
]
