type key = string
type value = string

type t = {
  document_id : string;
  data : (key * value) list;
}

let set_data _ _ = failwith "Not implemented"
let update_data _ _ = failwith "Not implemented"
let delete_field _ _ = failwith "Not implemented"
let document_id _ = failwith "Not implemented"
let data _ = failwith "Not implemented"
let string_of_document _ = failwith "Not implemented"
