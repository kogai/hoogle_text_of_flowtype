open Core

let () =
  let argv = Array.to_list Sys.argv in
  match argv with
    | [] | _::[] -> Utils.unreachable ~message:"Expected command"
    | _::file::rest ->
      print_endline (Printf.sprintf "Converting %s..." file);
      let result = Htof.parse file in
      print_endline result;
      exit 0
