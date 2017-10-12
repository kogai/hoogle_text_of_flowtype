open Core
open Parser_flow
open Translate

(* HTOF stands for Hoogle text of flow *)

let handle filepath =
  print_endline "Start\n";

  let result = filepath
               |> Utils.open_file
               |> (fun (content, source) -> program_file content source)
               |> (fun (ast, _) -> declarations ast)
               |> List.map ~f:print_endline

  in
  (* |> (fun (content, filename) -> program_file content filename)
     |> (fun (ocaml_ast, errors) -> Translate.declarations ocaml_ast, errors)
     |> (fun (xs, _) -> Option.value_exn (List.hd xs)) *)
  ()
