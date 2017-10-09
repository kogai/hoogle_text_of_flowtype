open Core
open OUnit2
open Parser_flow
open Htof

let root = "flow-typed/definitions/npm"
let specs = [
  "be able to convert libdef to text" >:: (fun ctx ->
      (* /Users/kogaishinichi/hoogle_text_of_flowtype/flow-typed/definitions/npm/awaiting_v2.x.x/flow_v0.33.x-/awaiting_v2.x.x.js *)
      let actual = handle @@ root ^ "/awaiting_v2.x.x/flow_v0.33.x-/awaiting_v2.x.x.js" in
      (* assert_equal actual "(string, number)" *)
      ()
    );
]
