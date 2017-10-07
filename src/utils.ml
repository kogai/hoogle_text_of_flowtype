open Core
open Parser_flow

(* val open_file: string -> (string * File_key.t option) *)
let open_file filename =
  let inx = In_channel.create filename in
  (* let lexbuf = Lexing.from_channel inx in
     lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
     parse_and_print lexbuf; *)
  In_channel.close inx;



