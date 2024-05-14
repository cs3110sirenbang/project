open Project

(* Read a database *)
let db = Database.read "data/og_db.json"

(* Read a collection from the database *)
let members = Database.get_collection "members" db
let () = print_endline "1 Collection: "
let () = print_endline (Collection.string_of_collection members)

(* Read a document from that collection *)
let old_daniel = Collection.get_document "3" members
let () = print_endline "2 Old Document: "
let () = print_endline (Document.string_of_document old_daniel)

(** Update the document *)
let daniel = Document.update_data [ ("age", Value.Int 19) ] old_daniel

let () = print_endline "3 Updated Document: "
let () = print_endline (Document.string_of_document daniel)

(** Set the updated document to the updated collection *)
let updated_members = Collection.set_document daniel members

let () = print_endline "4 Updated Collection: "
let () = print_endline (Collection.string_of_collection updated_members)

(** Set the updated collection to the database *)
let () = Database.set_collection updated_members db

(** See that the collection in the database is updated *)
let members = Database.get_collection "members" db

let () = print_endline "5 Collection: "
let () = print_endline (Collection.string_of_collection members)

(** Write the database to a new file *)
let () = Database.write "data/updated_db.json" db

(** Rollback database to before the updated collections was set in the database *)
let () = Database.rollback db

(** See that the collection in the database is back to the original *)
let members = Database.get_collection "members" db

let () = print_endline "6 Collection: "
let () = print_endline (Collection.string_of_collection members)

(** Write the rolled back database to another file *)
let () = Database.write "data/rollback_db.json" db

(** Create a new document from a json file *)
let clarkson = Document.from_json "data/doc.json"

let () = print_endline "7 Document: "
let () = print_endline (Document.string_of_document clarkson)

(** Add that new document to the members collection of the updated database *)
let updated_db = Database.read "data/updated_db.json"

let members = Database.get_collection "members" updated_db
let added_members = Collection.set_document clarkson members
let () = Database.set_collection added_members updated_db

(** Write the new database to another file *)
let () = Database.write "data/new_db.json" updated_db
