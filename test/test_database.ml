open OUnit2
open Project
open Database

let test_make _ =
  let db = Database.make "test_db" in
  assert_equal ~msg:"Database name is incorrect" "test_db"
    (Database.get_name db);
  assert_bool "Last updated should be set" (Database.get_last_updated db > 0.0)

let test_read_write _ =
  let filename = "./data/temp_db.json" in
  let db_read = read filename in
  assert_equal ~msg:"Read database name does not match" "SampleDB"
    (Database.get_name db_read);
  assert_equal ~msg:"Users collection should exist & have 2 documents" 2
    (List.length
       (Collection.get_documents (Database.get_collection "Users" db_read)))

let test_set_delete_rollback _ =
  let db = Database.make "test_db" in
  let col = Collection.make "test_collection" in
  Database.set_collection col db;
  assert_equal ~msg:"Collection was not added" col
    (Database.get_collection "test_collection" db);
  Database.delete_collection col db;
  assert_raises Not_found (fun () ->
      Database.get_collection "test_collection" db);
  Database.rollback db;
  assert_equal ~msg:"Rollback did not restore\n   collection" col
    (Database.get_collection "test_collection" db)

let database_tests =
  "test suite for database.ml"
  >::: [
         "test_make" >:: test_make;
         (* "test_string_of_database" >:: test_string_of_database; *)
         "test_read_write" >:: test_read_write;
         "test_set_delete_rollback" >:: test_set_delete_rollback;
       ]

let () = run_test_tt_main database_tests
