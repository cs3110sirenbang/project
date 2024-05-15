open Project

(* MS3 Demo Code *)

(* Part 1: Updating a document in a collection of a database *)

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

(* Update the document *)
let daniel = Document.update_data [ ("age", Value.Int 19) ] old_daniel
let () = print_endline "3 Updated Document: "
let () = print_endline (Document.string_of_document daniel)

(* Set the updated document to the updated collection *)
let updated_members = Collection.set_document daniel members
let () = print_endline "4 Updated Collection: "
let () = print_endline (Collection.string_of_collection updated_members)

(* Set the updated collection to the database *)

let () = Database.set_collection updated_members db

(* See that the collection in the database is updated *)
let members = Database.get_collection "members" db
let () = print_endline "5 Collection: "
let () = print_endline (Collection.string_of_collection members)

(* Write the database to a new file *)
let () = Database.write "data/updated_db.json" db

(* Rollback database to before the updated collections was set in the
   database *)
let () = Database.rollback db

(* See that the collection in the database is back to the original *)
let members = Database.get_collection "members" db
let () = print_endline "6 Collection: "
let () = print_endline (Collection.string_of_collection members)

(* Write the rolled back database to another file *)
let () = Database.write "data/rollback_db.json" db

(* Part 2: Adding a document *)

let db = Database.read "data/updated_db.json"

(* Create a new document from a json file *)
let clarkson = Document.from_json "data/doc.json"
let () = print_endline "7 Document: "
let () = print_endline (Document.string_of_document clarkson)

(* Add that new document to the members collection of the updated database *)
let members = Database.get_collection "members" db
let members' = Collection.set_document clarkson members
let () = Database.set_collection members' db

(* Write the new database to another file *)
let () = Database.write "data/new_db.json" db

(* Part 3: Querying a collection *)

let db = Database.read "data/new_db.json"
let members = Database.get_collection "members" db

(* Query COE members *)
let eng_members =
  Collection.where_field "college" (Collection.Is_equal_to (Value.Str "ENG"))
    members

let () = print_endline "8 Querying Collection: "
let () = print_endline (Collection.string_of_collection eng_members)

(* Query CAS members *)
let as_members =
  Collection.where_field "college" (Collection.Is_equal_to (Value.Str "A&S"))
    members

let () = print_endline "9 Querying Collection: "
let () = print_endline (Collection.string_of_collection as_members)

(* Set the CAS members collection as the members collection in the database *)
let () = Database.set_collection as_members db

(* Write the database to a new file *)
let () = Database.write "data/query_db.json" db
