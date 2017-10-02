let rec fib = function
  | 0 -> 0
  | 1 -> 1
| n -> fib (n - 2) + fib (n - 1)

let () =
  print_int @@ fib 10
