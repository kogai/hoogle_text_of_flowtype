open Parser_flow
open Ast
open Core
open Yojson

let tupple_str_of_list = function
  | [] -> ""
  | x::[] -> x
  | xs -> "(" ^ Utils.join xs ", " ^ ")"

let rec declarations (loc, statements, errors) =
  statements
  |> (fun xs -> List.map xs translate_statement)
  |> (fun xs -> List.fold xs ~init: [] ~f: (fun acc x -> match (acc, x) with
      | acc, Some x -> x :: acc 
      | acc, None -> acc
    ))

and translate_statement = Statement.(function
    | _, DeclareFunction ({ DeclareFunction.id; typeAnnotation }) ->
      let (_, identifier) = id in
      let (_, function_declaration) = typeAnnotation in
      Some (identifier ^ " ∷ " ^ translate_type function_declaration)
    | _ -> None
  )
and translate_type = Type.(function
    (* TODO: Consider how to treat type parameter *)
    | _, Function ({ Function.params; returnType; typeParameters }) ->
      let parameters = function_params params in
      let return_type = translate_type returnType in
      tupple_str_of_list parameters ^ " -> " ^ return_type
    | _, String -> "String"
    | _, Number -> "Float"
    | _, x ->
      print_endline "WILDCARD REACHED";
      exit 1
  )
and function_params = Function.Params.(function
    (* | _, { params; rest = Some (rest_loc, { Ast.Type.Function.RestElement.argument }) } -> *)
    (* TODO: Need to handle optional parameter *)
    | _, {
        Type.Function.Params.params;
        rest = Some (_, { Type.Function.RestParam.argument });
      } ->
      print_endline "Some rest params";
      List.map params (fun (_, { Type.Function.Param.typeAnnotation }) ->
          translate_type typeAnnotation)
    | _, { Type.Function.Params.params; rest = None } ->
      List.map params (fun (_, { Type.Function.Param.typeAnnotation }) ->
          translate_type typeAnnotation)
  )

let errors x = exit 1
