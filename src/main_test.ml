open Core
open OUnit2

let specs = [
  "always fail" >:: (fun ctx ->
      assert_equal true false 
    );
]

let suite = "suite" >::: specs
let () = run_test_tt_main suite
