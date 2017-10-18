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
      root
      |> gather_modules
      |> List.zip [{
          path = root ^ "definitions/npm/module_a_v1.10.x/flow_v0.25.x-/module_a_v1.10.x.js";
          name = "module_a";
          version ="v1.10.x";
        }; {
           path = root ^ "definitions/npm/module_b_v2.0/flow_v0.33.x-/module_b_v2.0.js";
           name = "module_b";
           version ="v2.0";
         }; {
           path = root ^ "definitions/npm/module_c_v3.x.x/flow_v0.25.x-/module_c_v3.x.x.js";
           name = "module_c";
           version ="v3.x.x";
         }
        ]
      |> (function
          | Some x -> x
          | None -> assert_failure "Number of elements hadn't matched")
      |> List.iter ~f:(fun ({ path; name; version; }, expect) ->
          assert_equal path expect.path;
          assert_equal name expect.name;
          assert_equal version expect.version;
        )
    )
]
