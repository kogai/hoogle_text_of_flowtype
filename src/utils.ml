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
