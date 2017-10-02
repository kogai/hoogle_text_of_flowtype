let rec fib = function
  | 0 -> 0
  | 1 -> 1
| n -> fib (n - 2) + fib (n - 1)

let () =
  let result = Parser_flow.jsx_pragma_expression "declare function foo()" in
  print_int @@ fib 10
