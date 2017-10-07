type t = Yojson.json

val declarations: Loc.t * Loc.t Ast.Statement.t list * (Loc.t * Ast.Comment.t') list -> string list
val translate_statement: Loc.t Ast.Statement.t -> string option
val errors: (Loc.t * Parse_error.t) list -> t
val tupple_str_of_list: string Core.List.t -> string
