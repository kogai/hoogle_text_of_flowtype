type t = Yojson.json

val program: Loc.t * Loc.t Ast.Statement.t list * (Loc.t * Ast.Comment.t') list -> t
val errors: (Loc.t * Parse_error.t) list -> t
