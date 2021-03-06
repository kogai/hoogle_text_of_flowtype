open Core
open Parser_flow

let open_file filename = (
  In_channel.read_all filename,
  Some (File_key.SourceFile filename)
)

(* Be able to replace by String.concat *)
let join xs ~sep =
  let rec f = function
    | [] -> ""
    | y::[] -> y
    | y::ys -> y ^ sep ^ f ys
  in
  f xs

let unreachable ?(message="") =
  print_endline "Unreachable path had reached";
  print_endline message;
  exit 1

let succ x =
  let n = Char.to_int x in
  let next = Char.of_int (n + 1) in
  Option.value_exn next

let is_valid_path file =
  match (Sys.file_exists file, Sys.is_file file, Filename.split_extension file) with
  | (`Yes, `Yes, (_, Some "js")) -> true
  | _ -> false
