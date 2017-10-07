type t = Yojson.json

val declarations: Loc.t * Loc.t Ast.Statement.t list * (Loc.t * Ast.Comment.t') list -> string list
val statement: Loc.t Ast.Statement.t -> string option
val errors: (Loc.t * Parse_error.t) list -> t
