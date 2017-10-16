(* HTOF stands for Hoogle text of flow *)

open Core
open Parser_flow
open Translate
open Cmdliner

type t = {
  (* flow-typed/definitions/npm/tape_v4.5.x/flow_v0.25.x-/tape_v4.5.x.js *)
  path: string; 

  (* name of module tape *)
  name: string;

  (* version of module like v4.5.x *)
  version: string;
}

let gather_modules root_dir = 
  []

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

(* TODO: No need to command line interface...
module Cmd : sig
  val name: string
  val run: string -> bool -> unit
  val term: unit Cmdliner.Term.t
end = struct
  let name = "hoogle_text_of_flowtype"

  let source =
    let doc = "Declaration file of Flow to convert" in
    Arg.(value & pos 0 string "" & info [] ~docv:"Source" ~doc)

  let dry_run =
    let doc = "Output to stdout instead of writting to file" in
    Arg.(value & flag & info ["d"; "dry-run"] ~docv:"Dry-run" ~doc)

  let run file dry_run =
    match Utils.is_valid_path file with
    | true ->
      print_endline (Printf.sprintf "Converting %s..." file);
      let result = parse file in
      if dry_run
      then print_endline result
      else print_endline result
    | false ->
      Utils.unreachable ~message:(Printf.sprintf "Invalid path [%s]" file)

  let term = Term.(const run $ source $ dry_run)
end
 *)
