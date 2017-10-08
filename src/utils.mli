open Parser_flow

val open_file: string -> (string * File_key.t option)
val join: string list -> sep:string -> string
val unreachable: ?message: string -> 'a
val succ: char -> char
