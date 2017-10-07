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
  statements
  |> (fun xs -> List.map xs statement)
  |> (fun xs -> List.fold xs ~init: [] ~f: (fun acc x -> match (acc, x) with
      | acc, Some x -> x :: acc 
      | acc, None -> acc
    ))

and statement = Statement.(function
    | loc, DeclareFunction ({ id; typeAnnotation }) ->
      let (_, identifier) = id in
      let (_, xxx) = typeAnnotation in
      params xxx;
      (* let result = match typeAnnotation with
         | Ast.Type.Function.(

          )
         in *)
      (* let argument_def = match typeAnnotation with 
         | (_,  x) ->
          (* print_endline @@ "[NAME] " ^ x.name; *)
          exit 1
         (* () *)
         | _ -> exit 1
         in *)
      (* and predicate (loc, p) = Ast.Type.Predicate.(
         let _type, value = match p with
          | Declared e -> "DeclaredPredicate", [|"value", expression e|]
          | Inferred -> "InferredPredicate", [||]
         in
         node _type loc value
         ) *)

      print_endline @@ "[IDENT] " ^ identifier;

      Some (identifier ^ " ∷ String -> Int")
    | _ -> None
  )
and params = Type.(function
    | _, Function x -> print_endline "IT IS FUNCTION"; exit 1
    | _ -> print_endline "IS NOT FUNCTION"; exit 1
  )

(* let convert cx tparams_map loc func =
   let {Ast.Type.Function.typeParameters; returnType; _} = func in
   let reason = mk_reason RFunctionType loc in
   let kind = Ordinary in
   let tparams, tparams_map =
    Anno.mk_type_param_declarations cx ~tparams_map typeParameters
   in
   let params = Func_params.convert cx tparams_map func in
   let body = empty_body in
   let return_t = Anno.convert cx tparams_map returnType in

   {reason; kind; tparams; tparams_map; params; body; return_t} *)

let errors x = exit 1
