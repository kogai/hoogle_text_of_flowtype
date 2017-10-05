open Parser_flow
open Ast
open Yojson

type t = json

let string x = `String x
let bool x = `Bool x
let obj props = `Assoc (Array.to_list props)
let array arr = `List (Array.to_list arr)
let number x = `Float x
let null = `Null
let regexp _loc _pattern _flags = `Null

let rec program (loc, statements, comments) =
  let body = List.map statement statements in
  exit 1
and statement = Statement.(function
  | loc, DeclareFunction d ->
    exit 1
  | _ -> exit 1
)

let errors x = exit 1
