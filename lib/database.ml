type t = {
  name : string;
  mutable last_updated : float;
  mutable collections : (string, Collection.t) Hashtbl.t;
  mutable prev_collections : (string, Collection.t) Hashtbl.t;
}

let list_of_values tbl = Hashtbl.fold (fun _ v acc -> v :: acc) tbl []

let string_of_database db =
  let collections_string =
    "["
    ^ (list_of_values db.collections
      |> List.map Collection.string_of_collection
      |> String.concat ",")
    ^ "]"
  in
  let prev_collections_string =
    "["
    ^ (list_of_values db.prev_collections
      |> List.map Collection.string_of_collection
      |> String.concat ",")
    ^ "]"
  in
  "{\"name\": \"" ^ db.name ^ "\"\n,\"last_updated\": "
  ^ string_of_float db.last_updated
  ^ "\n\n\"collections\": \n" ^ collections_string
  ^ "\n\n\"prev_collections\": \n" ^ prev_collections_string ^ "\n}"

let write filename db =
  let oc = open_out filename in
  Printf.fprintf oc "%s" (string_of_database db);
  close_out oc

let make name =
  {
    name;
    last_updated = Unix.time ();
    collections = Hashtbl.create 10;
    prev_collections = Hashtbl.create 10;
  }

let read_document (raw : Value.t) =
  let open Value in
  let id = map_of_value raw |> TMap.find "document_id" |> string_of_value in
  let data =
    map_of_value raw |> TMap.find "data" |> map_of_value |> TMap.bindings
  in
  Document.make id |> Document.set_data data

let read_collection (raw : Value.t) =
  let open Value in
  let name = map_of_value raw |> TMap.find "name" |> string_of_value in
  let collections =
    map_of_value raw |> TMap.find "documents" |> list_of_value
  in
  List.fold_left
    (fun acc v -> Collection.set_document (read_document v) acc)
    (Collection.make name) collections

let read_collections (raw : Value.t) =
  let open Value in
  let table = Hashtbl.create 10 in
  List.iter
    (fun v ->
      let collection = read_collection v in
      Hashtbl.add table (Collection.get_name collection) collection)
    (raw |> list_of_value);
  table

let read filename =
  let open Value in
  let raw = Parser.parse_file filename |> map_of_value in
  {
    name = TMap.find "name" raw |> string_of_value;
    last_updated = TMap.find "last_updated" raw |> float_of_value;
    collections = TMap.find "collections" raw |> read_collections;
    prev_collections = TMap.find "prev_collections" raw |> read_collections;
  }

let get_name db = db.name
let get_collection name db = Hashtbl.find db.collections name
let get_last_updated db = db.last_updated

let set_collection col db =
  db.last_updated <- Unix.time ();
  db.prev_collections <- Hashtbl.copy db.collections;
  Hashtbl.replace db.collections (Collection.get_name col) col

let delete_collection col db =
  db.last_updated <- Unix.time ();
  db.prev_collections <- Hashtbl.copy db.collections;
  Hashtbl.remove db.collections (Collection.get_name col)

let rollback db =
  db.last_updated <- Unix.time ();
  db.collections <- Hashtbl.copy db.prev_collections
