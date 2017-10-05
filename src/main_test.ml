open Core
open OUnit2

let specs = [
  "always success" >:: (fun ctx ->
      assert_equal true true 
    );
]

let suite = "suite" >::: specs @ Translate_test.specs
let () = run_test_tt_main suite
