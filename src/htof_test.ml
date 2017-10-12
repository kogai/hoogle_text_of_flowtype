open Core
open OUnit2
open Parser_flow
open Htof

let root = "fixture/htof"
let specs = [
  "be able to convert libdef to text" >:: (fun ctx ->
      let actual = handle @@ root ^ "/module.js" in
      let expect =  In_channel.read_all @@ root ^ "/module.txt" in
      assert_equal actual expect;
    );
]
