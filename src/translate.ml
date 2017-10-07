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
    | _, Function ({ Function.params; returnType; typeParameters }) ->
      let parameters = function_params params in
      let return_type = translate_type returnType in
      tupple_str_of_list parameters ^ " -> " ^ return_type
    | _, String -> "String"
    | _, Number -> "Float"
    | _, Boolean -> "Bool"
    | _, Array x -> "[" ^ translate_type x ^ "]"
    | _, Void -> "IO ()"
    | _, Generic { Type.Generic.id; typeParameters = None } -> generic id
    | _, x ->
      print_endline "WILDCARD REACHED";
      exit 1
  )
and function_params = Function.Params.(function
    (* TODO: Consider aobut named type parameter include namespace like $npm$bigi$BigInteger *)
    | _, {
        Type.Function.Params.params;
        rest = Some (_, { Type.Function.RestParam.argument });
      } ->
      let concrete = List.map params function_param in
      let result = function_param argument in
      List.append concrete [result]
    | _, { Type.Function.Params.params; rest = None } ->
      List.map params function_param
  )
and function_param = Type.Function.Param.(function
    | _, { typeAnnotation; optional; name } ->
      if optional then
        "Maybe " ^ translate_type typeAnnotation
      else
        translate_type typeAnnotation
  )
and generic = Type.Generic.(function
    | Identifier.Unqualified (_, x) -> String.lowercase x
    | Identifier.Qualified x ->
      print_endline @@ "Qualified ";
      exit 1
  )

let errors x = exit 1
