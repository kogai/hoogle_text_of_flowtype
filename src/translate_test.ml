open Core
open OUnit2
open Parser_flow
open Translate

let filename = Some (File_key.SourceFile "my-file.js")

let specs = [
  "be able to parse function declaration" >:: (fun ctx ->
      let content = "declare function f(x: string): number;" in
      let (ocaml_ast, errors) = program_file content filename in
      let (xs, _) = Translate.declarations ocaml_ast, errors in
      let actual = Option.value_exn (List.hd xs) in

      print_endline actual;
      assert_equal actual "f ∷ String -> Int"
    );
]
