open Parser_flow
open Ast
open Core
open Yojson

(* Perhaps no need to use JSON *)
type t = json

let string x = `String x
let bool x = `Bool x
let obj props = `Assoc (Array.to_list props)
let array arr = `List (Array.to_list arr)
let number x = `Float x
let null = `Null
let regexp _loc _pattern _flags = `Null

let rec declarations (loc, statements, errors) =
  let body = List.map statements statement in
  let body2 = List.fold body ~init: [] ~f: (fun acc x -> match (acc, x) with
    | acc, Some x -> x :: acc 
    | acc, None -> acc
  ) in

  body2

and statement = Statement.(function
  | loc, DeclareFunction d ->
    Some "f ∷ String -> Int"
  | _ -> None
)

let errors x = exit 1
