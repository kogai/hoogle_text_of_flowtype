val declarations: ?root:string -> Loc.t * Loc.t Ast.Statement.t list * (Loc.t * Ast.Comment.t') list -> string list
val translate_statement: Loc.t Ast.Statement.t -> (Loc.t * string) option
val tupple_str_of_list: string Core.List.t -> string

val errors: (Loc.t * Parse_error.t) list -> string
val relative_comment: Loc.t -> (Loc.t * Ast.Comment.t') list -> string list

(* TODO: translate class and interface method *)
