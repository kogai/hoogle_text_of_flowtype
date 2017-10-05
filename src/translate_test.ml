open Core
open OUnit2

let specs = [
  "always success" >:: (fun ctx ->
      assert_equal true true 
    );
]
