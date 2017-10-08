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
    (* ("fixture/basic.js", "f ∷ String -> Float");
       ("fixture/multiple.js", "f ∷ (String, Float) -> Bool");
       ("fixture/rest.js", "f ∷ (String, Float, [String]) -> IO ()");
       ("fixture/optional.js", "f ∷ Maybe String -> IO ()");
       ("fixture/generics.js", "f ∷ t -> [t]");
       ("fixture/type_alias.js", "f ∷ AType -> BType");
       ("fixture/curried.js", "f ∷ String -> Float -> Bool");
       ("fixture/bounded.js", "f ∷ String t => t -> [t]");
       ("fixture/existensial.js", "f ∷ a -> b");
       ("fixture/null.js", "f ∷ () -> String"); 
       ("fixture/any.js", "f ∷ a -> b");
       ("fixture/mixed.js", "f ∷ a -> b");
       ("fixture/empty.js", "f ∷ String -> IO ()");
       ("fixture/nullable.js", "f ∷ Maybe String -> IO ()");
       ("fixture/union.js", "f ∷ Union String Float -> IO ()");
       ("fixture/intersection.js", "f ∷ Intersection String Float -> IO ()");
       ("fixture/tupple.js", "f ∷ (String, Float) -> (Float, Bool)");
       ("fixture/literal.js", "f ∷ String -> Bool -> Float")
       ("fixture/typeof.js", "f ∷ String -> IO ()"); *)
    (* ("fixture/object.js", "f ∷ Object a => string -> a"); *)
    (* 
    Remained specs
    * Object
    * ObjectBound
    *)
  ] (fun (filepath, expect) ->
    filepath >:: (fun ctx ->
        let actual = get_result filepath in
        print_endline actual;
        assert_equal actual expect
      );
  )

let specs = [
  "be able to derive tupple from list" >:: (fun ctx ->
      let actual = Translate.tupple_str_of_list ["string";"number";] in
      assert_equal actual "(string, number)"
    );
]
