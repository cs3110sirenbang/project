type t = {
  name : string;
  mutable last_updated : float;
  mutable collections : (string, Collection.t) Hashtbl.t;
  mutable prev_collections : (string, Collection.t) Hashtbl.t;
}

let list_of_values tbl = Hashtbl.fold (fun _ v acc -> v :: acc) tbl []

let string_of_database db =
  let collections_string =
    list_of_values db.collections
    |> List.map Collection.string_of_collection
    |> String.concat "\n\n"
  in
  let prev_collections_string =
    list_of_values db.prev_collections
    |> List.map Collection.string_of_collection
    |> String.concat "\n\n"
  in
  "NAME: " ^ db.name ^ "\nLAST_UPDATED: "
  ^ string_of_float db.last_updated
  ^ "\n\nCOLLECTIONS: \n" ^ collections_string ^ "\n\nPREV_COLLECTIONS: \n"
  ^ prev_collections_string ^ "\n"

let read _ = failwith "not implemented yet"

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

let get_name db = db.name
let get_collection name db = Hashtbl.find db.collections name
let get_last_updated db = db.last_updated

let set_collection col db =
  db.last_updated <- Unix.time ();
  db.prev_collections <- db.collections;
  Hashtbl.replace db.collections (Collection.get_name col) col

let delete_collection col db =
  db.last_updated <- Unix.time ();
  db.prev_collections <- db.collections;
  Hashtbl.remove db.collections (Collection.get_name col)

let rollback db =
  db.last_updated <- Unix.time ();
  db.collections <- Hashtbl.copy db.prev_collections
