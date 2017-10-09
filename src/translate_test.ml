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
    (* "fixture/translate/basic";
       "fixture/translate/multiple";
       "fixture/translate/rest";
       "fixture/translate/optional";
       "fixture/translate/generics";
       "fixture/translate/type_alias";
       "fixture/translate/curried";
       "fixture/translate/bounded";
       "fixture/translate/existensial";
       "fixture/translate/null"; 
       "fixture/translate/any";
       "fixture/translate/mixed";
       "fixture/translate/empty";
       "fixture/translate/nullable";
       "fixture/translate/union";
       "fixture/translate/intersection";
       "fixture/translate/tuple";
       "fixture/translate/literal";
       "fixture/translate/typeof";
       "fixture/translate/object";
       "fixture/translate/object_bound";
       "fixture/translate/generic_existensial";
       "fixture/translate/comment";
       "fixture/translate/function";
    "fixture/translate/function_generic"; *)
       "fixture/translate/class";
    (* TODO:
       Class
       Interface
       Module *)
  ] (fun (filepath) ->
    filepath >:: (fun ctx ->
        let actual = get_result @@ filepath ^ ".js" in
        let expect = In_channel.read_all @@ filepath ^ ".txt" in
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
