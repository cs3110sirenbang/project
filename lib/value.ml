exception Type_error

module TMap : Map.S with type key = string = Map.Make (String)

type t =
  | Str of string
  | Int of int
  | Float of float
  | Bool of bool
  | List of t list
  | Map of t TMap.t

let rec make_strings lst =
  match lst with
  | [] -> []
  | s :: t -> Str s :: make_strings t

let rec make_ints lst =
  match lst with
  | [] -> []
  | s :: t -> Int s :: make_ints t

let rec make_floats lst =
  match lst with
  | [] -> []
  | s :: t -> Float s :: make_floats t

let rec make_bools lst =
  match lst with
  | [] -> []
  | s :: t -> Bool s :: make_bools t

let rec string_of_value value =
  match value with
  | Str s -> s
  | Int i -> string_of_int i
  | Float f -> string_of_float f
  | Bool b -> string_of_bool b
  | List s -> "[" ^ String.concat ", " (List.map string_of_value s) ^ "]"
  | Map m ->
      "{ "
      ^ String.concat ", "
          (List.map
             (fun (k, v) -> k ^ ": " ^ string_of_value v)
             (TMap.bindings m))
      ^ " }"

let compare v1 v2 =
  match (v1, v2) with
  | Int v1, Int v2 -> Int.compare v1 v2
  | Str v1, Str v2 -> String.compare v1 v2
  | Float v1, Float v2 -> Float.compare v1 v2
  | Bool v1, Bool v2 -> Bool.compare v1 v2
  | List v1, List v2 -> if v1 = v2 then 0 else -2
  | Map v1, Map v2 -> if TMap.bindings v1 = TMap.bindings v2 then 0 else -2
  | _, _ -> raise Type_error

let int_of_value v =
  match v with
  | Int i -> i
  | _ -> raise Type_error

let float_of_value v =
  match v with
  | Float f -> f
  | _ -> raise Type_error

let bool_of_value v =
  match v with
  | Bool b -> b
  | _ -> raise Type_error

let list_of_value v =
  match v with
  | List l -> l
  | _ -> raise Type_error

let map_of_value v =
  match v with
  | Map m -> m
  | _ -> raise Type_error

let in_int f v =
  match v with
  | Int i -> f i
  | _ -> raise Type_error

let in_float f v =
  match v with
  | Float i -> f i
  | _ -> raise Type_error

let in_bool f v =
  match v with
  | Bool i -> f i
  | _ -> raise Type_error

let in_string f v =
  match v with
  | Str i -> f i
  | _ -> raise Type_error

let out_int f v =
  match f v with
  | i -> Int i

let out_float f v =
  match f v with
  | i -> Float i

let out_bool f v =
  match f v with
  | i -> Bool i

let out_string f v =
  match f v with
  | i -> Str i

let check_type v1 v2 =
  match (v1, v2) with
  | Str _, Str _
  | Int _, Int _
  | Float _, Float _
  | Bool _, Bool _
  | List _, List _
  | Map _, Map _ -> ()
  | _, _ -> raise Type_error
