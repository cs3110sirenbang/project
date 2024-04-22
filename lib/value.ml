exception Type_error

module TMap : Map.S with type key = string = Map.Make (String)

type t =
  | Str of string
  | Int of int
  | Float of float
  | Bool of bool
  | List of t list
  | Map of t TMap.t

let make_strings = failwith "Not implemented"
let make_ints = failwith "Not implemented"
let make_floats = failwith "Not implemented"
let make_bools = failwith "Not implemented"
let make_lists = failwith "Not implemented"
let make_map = failwith "Not implemented"
let string_of_value = failwith "Not implemented"
let compare = failwith "Not implemented"
let int_of_value = failwith "Not implemented"
let float_of_value = failwith "Not implemented"
let bool_of_value = failwith "Not implemented"
let list_of_value = failwith "Not implemented"
let map_of_value = failwith "Not implemented"
let in_int = failwith "Not implemented"
let in_float = failwith "Not implemented"
let in_bool = failwith "Not implemented"
let in_string = failwith "Not implemented"
let out_int = failwith "Not implemented"
let out_float = failwith "Not implemented"
let out_bool = failwith "Not implemented"
let out_string = failwith "Not implemented"
