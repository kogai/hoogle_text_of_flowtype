open Core
open OUnit2
open Utils
open Translate

let specs = [
  "be able to read content from file" >:: (fun ctx ->
      let actual = open_file "fixture/basic.js" in
      assert_equal 
        actual
        ("declare function f(x: string): number;\n",
         Some (File_key.SourceFile "fixture/basic.js"))
    );
  "be able to derive successor" >:: (fun ctx ->
      assert_equal (succ 'a') 'b';
    );
]
