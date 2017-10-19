open Core
open Parser_flow
open Translate
open Cmdliner

type t = {
  path: string; 
  name: string;
  version: string;
}

let rec gather_directories dir =
  match Sys.is_directory dir with
  | `Yes ->
    dir::(dir
          |> Sys.ls_dir
          |> List.map ~f:(fun d -> gather_directories @@ dir ^ "/" ^ d)
          |> List.concat)
  | _ -> []

let gather_modules root_dir =
  root_dir
  |> gather_directories
  |> List.filter ~f:(fun d -> Str.string_match (Str.regexp ".*_v[0-9.x]+$") d 0)
  |> List.map ~f:(fun d ->
      print_endline d;
      {
        path = d;
        name = d;
        version = d;
      })

let parse filepath = filepath
                     |> Utils.open_file
                     |> (fun (content, source) -> program_file content source)
                     |> (fun (ast, _) -> translate ~root:"https://github.com/flowtype/flow-typed/tree/master/definitions" ast)
                     |> String.concat ~sep:""
                     |> String.chop_suffix_exn ~suffix:"\n"

let run () =
  let dirs = "flow-typed/definitions/npm/tape_v4.5.x"
             |> Sys.readdir
             |> Array.to_list in
  List.iter ~f:print_endline dirs;
  ()
