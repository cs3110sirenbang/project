type key = string
type value = string

type t = {
  document_id : string;
  data : (key * value) list;
}

let make id = { document_id = id; data = [] }

let set_data pairs document =
  { document_id = document.document_id; data = pairs }

let update_data pairs document =
  let updated_data =
    List.map
      (fun (k, v) ->
        if List.mem_assoc k pairs then (k, List.assoc k pairs) else (k, v))
      document.data
    @ List.filter (fun (k, _) -> not (List.mem_assoc k document.data)) pairs
  in
  { document_id = document.document_id; data = updated_data }

let delete_field key document =
  if not (List.mem_assoc key document.data) then raise Not_found
  else
    {
      document_id = document.document_id;
      data = List.remove_assoc key document.data;
    }

let document_id document = document.document_id
let data document = document.data
let string_of_document _ = failwith "Not implemented"
