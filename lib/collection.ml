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

let where_field field query col =
  let documents' =
    List.filter
      (fun doc -> List.assoc_opt field (data doc) <> None)
      col.documents
  in
  let col = { col with documents = documents' } in
  let get_field field doc = List.assoc field (data doc) in
  {
    name = col.name;
    documents =
      (match query with
      | Is_equal_to value ->
          List.filter (fun doc -> get_field field doc = value) col.documents
      | Is_not_equal_to value ->
          List.filter (fun doc -> get_field field doc <> value) col.documents
      | Is_in values ->
          List.filter
            (fun doc -> List.mem (get_field field doc) values)
            col.documents
      | Is_not_in values ->
          List.filter
            (fun doc -> not (List.mem (get_field field doc) values))
            col.documents
      | _ -> raise (Invalid_argument "Query not supported"));
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

let string_of_collection col =
  let docs =
    col.documents |> List.map string_of_document |> String.concat ", "
  in
  "{\"name\": \"" ^ col.name ^ "\", \"documents\": [" ^ docs ^ "]}"
