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
    "fixture/basic";
    "fixture/multiple";
    "fixture/rest";
    "fixture/optional";
    "fixture/generics";
    "fixture/type_alias";
    "fixture/curried";
    "fixture/bounded";
    "fixture/existensial";
    "fixture/null"; 
    "fixture/any";
    "fixture/mixed";
    "fixture/empty";
    "fixture/nullable";
    "fixture/union";
    "fixture/intersection";
    "fixture/tuple";
    "fixture/literal";
    "fixture/typeof";
    "fixture/object";
    "fixture/object_bound";
    "fixture/generic_existensial";
    "fixture/comment";
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
