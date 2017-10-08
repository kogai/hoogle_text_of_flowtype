open Parser_flow

val open_file: string -> (string * File_key.t option)
val join: string list -> string -> string
val unreachable: ?message: string -> 'a
val succ: char -> char
