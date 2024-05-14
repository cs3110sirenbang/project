open Test_value
open Test_collection
open Test_document
open Test_json
open Test_database
open OUnit2

let run_suites lst = List.iter (fun suite -> run_test_tt_main suite) lst
let _ = run_suites [ value_tests; collection_tests; document_tests; database_tests; parser_tests; lex_tests ]
