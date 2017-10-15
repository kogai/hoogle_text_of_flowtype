(* HTOF stands for Hoogle text of flow *)

open Core
open Parser_flow
open Translate

let parse filepath = filepath
                      |> Utils.open_file
                      |> (fun (content, source) -> program_file content source)
                      |> (fun (ast, _) -> declarations ast)
                      |> String.concat ~sep:""
                      |> String.chop_suffix_exn ~suffix:"\n"
