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

module Cmd : sig
  val f: string -> string
end = struct
  let f x = x ^ "!!"
end
(* open Cmdliner *)

(* let cmd =
  let doc = "remove files or directories" in
  let man = [
    `S Manpage.s_description;
    `P "$(tname) removes each specified $(i,FILE). By default it does not
          remove directories, to also remove them and their contents, use the
          option $(b,--recursive) ($(b,-r) or $(b,-R)).";
    `P "To remove a file whose name starts with a `-', for example
          `-foo', use one of these commands:";
    `P "rm -- -foo"; `Noblank;
    `P "rm ./-foo";
    `P "$(tname) removes symbolic links, not the files referenced by the
          links.";
    `S Manpage.s_bugs; `P "Report bugs to <hehey at example.org>.";
    `S Manpage.s_see_also; `P "$(b,rmdir)(1), $(b,unlink)(2)" ]
  in
  Term.(const rm $ prompt $ recursive $ files),
  Term.info "rm" ~version:"v1.0.2" ~doc ~exits:Term.default_exits ~man *)

