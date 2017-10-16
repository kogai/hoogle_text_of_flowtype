open Core
open OUnit2
open Parser_flow
open Htof

let root = "fixture/htof"
let specs = [
  "be able to convert libdef to text" >:: (fun ctx ->
      let actual = parse @@ root ^ "/module.js" in
      let expect =  In_channel.read_all @@ root ^ "/module.txt" in
      assert_equal actual expect;
    );

  "be able to gather modules" >:: (fun ctx ->
      let actual = root ^ "/flow-typed"
                   |> gather_modules
                   |> List.hd_exn in
      assert_equal actual.path "fixture/htof/flow-typed/definitions/npm/tape_v4.5.x/flow_v0.25.x-/tape_v4.5.x.js";
      assert_equal actual.name "tape";
      assert_equal actual.version "v4.5.x";
    )
]
