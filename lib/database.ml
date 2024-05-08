type t = {
  name : string;
  mutable last_updated : float;
  mutable collections : (string, Collection.t) Hashtbl.t;
  mutable prev_collections : (string, Collection.t) Hashtbl.t;
}

(* let string_of_database db = *)

let read _ = failwith "not implemented yet"
let write _ _ = failwith "not implemented yet"

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
