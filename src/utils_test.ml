open Core
open OUnit2
open Utils
open Translate

let specs = [
  "be able to read content from file" >:: (fun ctx ->
      let actual = open_file "fixture/translate_function_actual.js" in
      assert_equal 
        actual
        ("declare function f(x: string): number;\n",
         Some (File_key.SourceFile "fixture/translate_function_actual.js"))
    );
]
