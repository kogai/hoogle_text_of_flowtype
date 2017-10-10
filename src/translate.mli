type t =
  | ModuleDeclare of Loc.t * string
  | FunctionDeclare of Loc.t * string
  | NoDeclare

val translate: ?root:string -> Loc.t * Loc.t Ast.Statement.t list * (Loc.t * Ast.Comment.t') list -> string list
val translate_statement: root:string -> comments:(Loc.t * Ast.Comment.t') list -> Loc.t Ast.Statement.t -> t
val tupple_str_of_list: string Core.List.t -> string

val errors: (Loc.t * Parse_error.t) list -> string
val relative_comment: Loc.t -> (Loc.t * Ast.Comment.t') list -> string list

(* TODO: translate class and interface method *)
