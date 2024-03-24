open Document

type t = {
  name : string;
  documents : Document.t list;
}

type query =
  | Is_less_than of value
  | Is_less_than_or_equal_to of value
  | Is_equal_to of value
  | Is_greater_than of value
  | Is_greater_than_or_equal_to of value
  | Is_not_equal_to of value
  | Is_in of value list
  | Is_not_in of value list

let document _ _ = failwith "Not implemented"
let make _ = failwith "Not implemented"
let where_field _ _ _ = failwith "Not implemented"
let delete _ _ = failwith "Not implemented"
let get_documents _ = failwith "Not implemented"
let string_of_collection _ = failwith "Not implemented"
