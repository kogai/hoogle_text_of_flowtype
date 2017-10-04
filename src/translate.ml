open Parser_flow

module Translate : (sig
  type t
  val program: Loc.t * Loc.t Ast.Statement.t list * (Loc.t * Ast.Comment.t') list -> t
  val errors: (Loc.t * Parse_error.t) list -> t
  val string_of_json : t -> string
end) = struct
  open Yojson
  type t = json

  let string x = `String x
  let bool x = `Bool x
  let obj props = `Assoc (Array.to_list props)
  let array arr = `List (Array.to_list arr)
  let number x = `Float x
  let null = `Null
  let regexp _loc _pattern _flags = `Null

  let program x = exit (1)
  let errors x = exit (1)
  let string_of_json x = exit (1)
end

include Translate
