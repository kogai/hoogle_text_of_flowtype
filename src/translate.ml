open Parser_flow
open Ast
open Core
open Yojson

let tupple_str_of_list = function
  | [] -> ""
  | x::[] -> x
  | xs -> "(" ^ Utils.join xs ", " ^ ")"

let type_of_type_var base =
  let ty = ref '`' in (* Former of a'' *)
  base
  |> (fun x -> String.split x ' ')
  |> (fun xs -> List.map xs (function
      | "*" ->
        let next = Utils.succ !ty in
        ty := next;
        Char.to_string next
      | x -> x
    ))
  |> (fun xs -> Utils.join xs " ")

let rec declarations (loc, statements, errors) =
  statements
  |> (fun xs -> List.map xs translate_statement)
  |> (fun xs -> List.fold xs ~init: [] ~f: (fun acc x -> match (acc, x) with
      | acc, Some x -> x :: acc 
      | acc, None -> acc
    ))

and translate_statement = Statement.(function
    | _, DeclareFunction ({ DeclareFunction.id; typeAnnotation; }) ->
      let (_, identifier) = id in
      let (_, function_declaration) = typeAnnotation in
      let result = identifier ^ " ∷ " ^ translate_type function_declaration in
      Some (type_of_type_var result)
    | _ -> None
  )
and gather_generic_names {Type.ParameterDeclaration.params} = 
  List.map params (fun (_, { Type.ParameterDeclaration.TypeParam.name }) -> name)

and gather_bounds {Type.ParameterDeclaration.params} = 
  params
  |> (fun ps -> List.filter ps (fun (_, { Type.ParameterDeclaration.TypeParam.bound }) ->
      Option.is_some bound
    ))
  |> (fun ps -> List.map ps (fun (_, { Type.ParameterDeclaration.TypeParam.name; bound }) ->
      match bound with
      | Some b -> (b, name)
      | _ -> Utils.unreachable ~message:"Unreachable bounded parameter"
    ))
  |> (fun ps -> List.map ps (fun ((_, b), name) ->
      let bound = translate_type b in
      bound ^ " " ^ String.lowercase name ^ " => "
    ))
  |> tupple_str_of_list

and translate_type ?(generic_names=[]) = Type.(function
    | _, Function ({ Function.params; returnType; typeParameters = Some (_, typeDeclaration) }) ->
      (* We have to gather TypeParameterDeclaration in current path *)
      let generic_names = gather_generic_names typeDeclaration in
      let bounds = gather_bounds typeDeclaration in
      let parameters = function_params ~generic_names params in
      let return_type = translate_type ~generic_names returnType in
      bounds ^ tupple_str_of_list parameters ^ " -> " ^ return_type

    | _, Function ({ Function.params; returnType; typeParameters = None }) ->
      let parameters = function_params params in
      let return_type = translate_type returnType in
      tupple_str_of_list parameters ^ " -> " ^ return_type

    | _, String -> "String"
    | _, Number -> "Float"
    | _, Boolean -> "Bool"
    | _, Object x -> "Object"
    | _, Array x -> "[" ^ translate_type ~generic_names x ^ "]"
    | _, Void -> "IO ()"
    | _, Generic { Type.Generic.id; typeParameters = None } -> generic ~generic_names id
    | _, Exists -> "*"
    | _, x -> Utils.unreachable ~message:"WILDCARD REACHED"
  )
and function_params ?(generic_names=[]) = Function.Params.(function
    (* TODO: Consider aobut named type parameter include namespace like $npm$bigi$BigInteger *)
    | _, {
        Type.Function.Params.params;
        rest = Some (_, { Type.Function.RestParam.argument });
      } ->
      let arguments = List.map params (function_param ~generic_names) in
      let rest_arguments = function_param ~generic_names argument in
      List.append arguments [rest_arguments]
    | _, { Type.Function.Params.params; rest = None } ->
      List.map params (function_param ~generic_names)
  )
and function_param ~generic_names = Type.Function.Param.(function
    | _, { typeAnnotation; optional; name } ->
      if optional then
        "Maybe " ^ translate_type ~generic_names  typeAnnotation
      else
        translate_type ~generic_names typeAnnotation
  )
and generic ~generic_names = Type.Generic.Identifier.(function
    | Unqualified (_, x) ->
      let is_generic =
        generic_names
        |> (fun ns -> List.find ns (fun n -> n = x))
        |> Option.is_some
      in
      if is_generic then
        String.lowercase x
      else
        x
    | Qualified x -> Utils.unreachable ~message:"GenericQualified"
  )

let errors x = exit 1
