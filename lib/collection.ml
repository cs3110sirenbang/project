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

let make name = { name; documents = [] }

let get_document id col =
  List.find (fun doc -> Document.document_id doc = id) col.documents

let set_document doc col =
  let filtered_col =
    List.filter (fun d -> document_id d <> document_id doc) col.documents
  in
  { name = col.name; documents = doc :: filtered_col }

let check_query_type query =
  match query with
  | Is_greater_than value
  | Is_less_than value
  | Is_greater_than_or_equal_to value
  | Is_less_than_or_equal_to value -> (
      match value with
      | Map _ | List _ -> raise Value.Type_error
      | _ -> ())
  | _ -> ()

let check_types = function
  | [] -> ()
  | h :: t -> List.iter (fun value -> Value.check_type value h) t

let where_field field query col =
  check_query_type query;
  let documents' =
    List.filter
      (fun doc -> List.assoc_opt field (data doc) <> None)
      col.documents
  in
  let col = { col with documents = documents' } in
  let get_field field doc = List.assoc field (data doc) in
  let equal_to value doc = Value.compare value (get_field field doc) = 0 in
  let not_equal_to value doc = not (equal_to value doc) in
  let is_in values doc = List.exists (fun value -> equal_to value doc) values in
  let is_not_in values doc = not (is_in values doc) in
  let greater_than value doc = Value.compare value (get_field field doc) = 1 in
  let less_than value doc = Value.compare value (get_field field doc) = -1 in
  let greater_than_or_equal_to value doc =
    greater_than value doc || equal_to value doc
  in
  let less_than_or_equal_to value doc =
    greater_than value doc || equal_to value doc
  in
  {
    name = col.name;
    documents =
      (let f =
         match query with
         | Is_equal_to value -> equal_to value
         | Is_not_equal_to value -> not_equal_to value
         | Is_in values ->
             check_types values;
             is_in values
         | Is_not_in values ->
             check_types values;
             is_not_in values
         | Is_greater_than value -> greater_than value
         | Is_less_than value -> less_than value
         | Is_greater_than_or_equal_to value -> greater_than_or_equal_to value
         | Is_less_than_or_equal_to value -> less_than_or_equal_to value
       in
       List.filter f col.documents);
  }

let delete document col =
  {
    name = col.name;
    documents =
      List.filter
        (fun doc -> document_id doc <> document_id document)
        col.documents;
  }

let get_documents col = col.documents
let get_name col = col.name

let string_of_collection ?(tabs = 0) col =
  let tabs_str = String.make tabs '\t' in
  let docs =
    col.documents
    |> List.map (string_of_document ~tabs:(tabs + 2))
    |> String.concat ", \n"
  in
  tabs_str ^ "{\n" ^ tabs_str ^ "\t\"name\": \"" ^ col.name ^ "\", \n"
  ^ tabs_str ^ "\t\"documents\": [" ^ tabs_str ^ "\n" ^ docs ^ "\n" ^ tabs_str
  ^ "\t]\n" ^ tabs_str ^ "}"

let to_json col filename =
  let oc = open_out filename in
  Printf.fprintf oc "%s" (string_of_collection col);
  close_out oc

let union _ _ = failwith "not implemented"
let intersect _ _ = failwith "not implemented"
let difference _ _ = failwith "not implemented"
