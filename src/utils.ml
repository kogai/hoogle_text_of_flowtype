open Core
open Parser_flow

let open_file filename = (
  In_channel.read_all filename,
  Some (File_key.SourceFile filename)
)

let join xs sep =
  let rec f = function
    | [] -> ""
    | y::[] -> y
    | y::ys -> y ^ sep ^ f ys
  in
  f xs

let unreachable () =
  print_endline "Unreachable path had reached.";
  exit 1
