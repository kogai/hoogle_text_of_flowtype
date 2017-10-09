open Parser_flow
open Ast
open Core
open Yojson

let tupple_str_of_list = function
  | [] -> ""
  | x::[] -> x
  | xs -> "(" ^ Utils.join xs ", " ^ ")"

let rec find_start_char c = function
  | [] -> c
  | x::xs ->
    if x = String.of_char c then
      find_start_char (Utils.succ c) xs
    else
      find_start_char c xs

let type_of_type_var base =
  let constraints = base
                    |> String.split ~on:' ' in
  let ty = ref (find_start_char 'a' constraints) in (* Former of a'' *)
  constraints
  |> List.map ~f:(function
      | "*" ->
        let current = !ty in
        ty := Utils.succ current;
        Char.to_string current
      | x -> x
    )
  |> Utils.join ~sep:" "

let rec declarations ?(root="") (loc, statements, comments) =
  statements
  |> List.map ~f:translate_statement
  |> List.fold ~init: [] ~f: (fun acc x -> match (acc, x) with
      | acc, Some (loc, dec) ->
        let comments = relative_comment loc comments in
        let url = match Loc.source loc with
          | Some source ->
            let { Loc.start } = loc in
            let { Loc.line } = start in
            "@url " ^ (File_key.to_string source) ^ "#L" ^ string_of_int line
          | None -> ""
        in
        (String.concat ~sep:"\n" (comments @ [url] @ [dec])) :: acc
      | acc, None -> acc
    )
  |> List.map ~f:(fun d -> d ^ "\n")

and relative_comment { Loc.start } comments
  = comments
    |> List.fold
      ~init:[]
      ~f:(fun acc ({Loc._end}, ast) ->
          (let distance = Loc.pos_cmp start _end in
           if distance = 1 then
             match ast with
             | Comment.Block c -> String.split_lines c
             | Comment.Line c -> [c]
           else
             [""]
          )::acc)
    |> List.concat
    |> List.filter ~f:(fun x -> not @@ String.is_empty x)
    |> List.mapi ~f:(fun i c -> if i = 0 then "-- | " ^ c else "--   " ^ c)

and translate_statement = Statement.(function
    | _, DeclareFunction ({
        DeclareFunction.id=(loc, id);
        typeAnnotation=(_, body);
      }) ->
      (loc, id ^ " ∷ " ^ translate_type body)
      |> (fun (loc, base) -> (loc, (type_of_type_var base)))
      |> Option.return
    | _, TypeAlias {
        TypeAlias.id=(loc, id);
        typeParameters = None;
        right;
      } ->
      (loc, id ^ " ∷ " ^ translate_type right)
      |> (fun (loc, base) -> (loc, (type_of_type_var base)))
      |> Option.return
    | _, TypeAlias {
        TypeAlias.id=(loc, id);
        typeParameters = Some (_, typeParameter);
        right;
      } ->
      let generic_names = gather_generic_names typeParameter in
      (loc, id ^ " ∷ " ^ translate_type ~generic_names right)
      |> (fun (loc, base) -> (loc, (type_of_type_var base)))
      |> Option.return
    | _ ->
      ignore @@ Utils.unreachable ~message:"No declare";
      None
  )
and gather_generic_names {Type.ParameterDeclaration.params} = 
  List.map params (fun (_, { Type.ParameterDeclaration.TypeParam.name }) -> name)

and gather_bounds {Type.ParameterDeclaration.params} = 
  params
  |> List.filter ~f:(fun (_, { Type.ParameterDeclaration.TypeParam.bound }) ->
      Option.is_some bound
    )
  |> List.map ~f:(fun (_, { Type.ParameterDeclaration.TypeParam.name; bound }) ->
      match bound with
      | Some b -> (b, name)
      | _ -> Utils.unreachable ~message:"Unreachable bounded parameter"
    )
  |> List.map ~f:(fun ((_, b), name) ->
      let bound = translate_type b in
      bound ^ " " ^ String.lowercase name
    )

and constraints ts =
  ts
  |> tupple_str_of_list
  |> (fun x ->
      if String.length x > 0 then x ^ " => "
      else x
    )

and translate_function ~bounds ~generic_names ~params ~return_type =
  let parameters = function_params ~generic_names params in
  let return_type = translate_type ~generic_names return_type in
  String.concat ~sep:"" [
    constraints bounds;
    tupple_str_of_list parameters;
    " -> ";
    return_type;
  ]

and translate_type ?(generic_names=[]) = Type.(function
    | _, Function ({ Function.params; returnType = return_type; typeParameters = Some (_, typeDeclaration) }) ->
      (* We have to gather TypeParameterDeclaration in current path *)
      let generic_names = gather_generic_names typeDeclaration in
      let bounds = gather_bounds typeDeclaration in
      translate_function ~bounds ~generic_names ~params ~return_type

    | _, Function ({ Function.params; returnType = return_type; typeParameters = None }) ->
      translate_function ~bounds:[] ~generic_names ~params ~return_type

    | _, Union (t0, t1, ts) -> translate_types "Union " (t0::t1::ts)
    | _, Intersection (t0, t1, ts) -> translate_types "Intersection " (t0::t1::ts)
    | _, Tuple ts -> ts
                     |> List.map ~f:translate_type
                     |> tupple_str_of_list 
    | _, String | _, StringLiteral _ -> "String"
    | _, Number | _, NumberLiteral _ -> "Float"
    | _, Boolean | _, BooleanLiteral _ -> "Bool"
    (* TODO:
       Consider to replace `Object` to constarint `Object a` *)
    | _, Object _ -> "Object"
    | _, Array t -> "[" ^ translate_type ~generic_names t ^ "]"
    | _, Void -> "IO ()"
    | _, Null -> "()"
    | _, Generic { Type.Generic.id; typeParameters = None } -> generic ~generic_names id
    | _, Exists -> "*"
    | _, Mixed -> "*"
    | _, Any -> "*"
    | _, Empty -> "IO ()"
    | _, Typeof t -> translate_type t
    | _, Nullable t -> "Maybe " ^ translate_type t
    | _, _ -> Utils.unreachable ~message:"WILDCARD REACHED"
  )

and translate_types kind ts =
  kind ^ (ts
          |> List.map ~f:translate_type
          |> Utils.join ~sep:" ")

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
        |> List.find ~f:(fun n -> n = x)
        |> Option.is_some
      in
      if is_generic then
        String.lowercase x
      else
        (match x with
         | "undefined" -> "IO ()"
         | _ -> x)

    | Qualified x -> Utils.unreachable ~message:"GenericQualified"
  )

let errors x = exit 1
