open Core
open OUnit2
open Parser_flow
open Translate

let filename = Some (File_key.SourceFile "my-file.js")

let specs = [
  "be able to parse function declaration" >:: (fun ctx ->
      let content = "declare function f(x: string): number;" in
      let (ocaml_ast, errors) = program_file content filename in
      let (result, _) = Translate.program ocaml_ast, errors in
      let actual = Yojson.pretty_to_string result in
      print_endline actual;
      assert_equal actual ""
    );
]
