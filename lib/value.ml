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
  | s :: t -> (Str s) :: make_strings t 

let rec make_ints lst = 
  match lst with
  | [] -> []
  | s :: t -> (Int s) :: make_ints t

let rec make_floats lst = 
  match lst with
  | [] -> []
  | s :: t -> (Float s) :: make_floats t

let rec make_bools lst =
  match lst with
  | [] -> []
  | s :: t -> (Bool s) :: make_bools t

(* let rec make_lists lst = List lst *)
let make_map map = Map map

let rec string_of_value value = 
  match value with
  | Str s -> s
  | Int i -> string_of_int i
  | Float f -> string_of_float f
  | Bool b -> string_of_bool b
  | List s -> "[" ^ (String.concat ", " (List.map string_of_value s)) ^ "]"
  | Map m -> "{ " ^ (String.concat ", " (List.map (fun (k, v) -> k ^ ": " ^ (string_of_value v)) (TMap.bindings m))) ^ " }"

let compare v1 v2 = 
  match v1, v2 with
  | Str s1, Str s2 -> String.compare s1 s2
  | Int i1, Int i2 -> compare i1 i2
  | Float f1, Float f2 -> compare f1 f2
  | Bool b1, Bool b2 -> compare b1 b2
  | List l1, List l2 -> compare l1 l2
  | Map m1, Map m2 -> compare m1 m2
  | _ -> raise Type_error

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

let in_int f v = match v with
  | Int i -> f i
  | _ -> raise Type_error

let in_float f v = match v with
  | Float i -> f i
  | _ -> raise Type_error

let in_bool f v = match v with
  | Bool i -> f i
  | _ -> raise Type_error 
  
let in_string f v = match v with
  | Str i -> f i
  | _ -> raise Type_error

let out_int f v = match f v with
  | i -> Int i

let out_float f v = match f v with
  | i -> Float i

let out_bool f v = match f v with
  | i -> Bool i

let out_string f v = match f v with
  | i -> Str i
