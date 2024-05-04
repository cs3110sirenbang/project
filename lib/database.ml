type t = {
  name : string;
  collections : (string, Collection.t) Hashtbl.t;
}

let read _ = failwith "not implemented yet"
let write _ _ = failwith "not implemented yet"
let make name = { name; collections = Hashtbl.create 10 }
let get_name db = db.name
let get_collection name db = Hashtbl.find db.collections name

let set_collection col db =
  Hashtbl.replace db.collections (Collection.get_name col) col

let delete_collection col db =
  Hashtbl.remove db.collections (Collection.get_name col)
