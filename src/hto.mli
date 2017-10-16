type t = {
  (* flow-typed/definitions/npm/tape_v4.5.x/flow_v0.25.x-/tape_v4.5.x.js *)
  path: string; 

  (* name of module tape *)
  name: string;

  (* version of module like v4.5.x *)
  version: string;
}

val gather_modules: string -> t list
val parse: string -> string
val run: unit -> unit
