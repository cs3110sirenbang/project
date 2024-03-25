open OUnit2
open Project

let empty_doc = Collection.make "" |> Collection.document "0" |> fst
let data = [ ("a", "A"); ("b", "B"); ("c", "C") ]
let doc = empty_doc |> Document.set_data data

let test_document =
  "test suite for document"
  >::: [
         ("test set_data" >:: fun _ -> assert_equal data (doc |> Document.data));
         ( "test update_data" >:: fun _ ->
           assert_equal "a"
             (doc
             |> Document.update_data [ ("a", "a") ]
             |> Document.data |> List.assoc "a") );
         ( "test update_data 2" >:: fun _ ->
           assert_equal
             [ ("a", "A"); ("b", "B"); ("c", "C") ]
             (doc
             |> Document.update_data [ ("b", "b"); ("c", "c") ]
             |> Document.data) );
         ( "test update_data 3" >:: fun _ ->
           assert_raises Not_found (fun _ ->
               doc
               |> Document.update_data [ ("a", "a"); ("d", "d") ]
               |> Document.data) );
         ( "test delete_field" >:: fun _ ->
           assert_equal (List.tl data)
             (doc |> Document.delete_field "a" |> Document.data) );
         ( "test delete_field2" >:: fun _ ->
           assert_equal []
             (doc |> Document.delete_field "a" |> Document.delete_field "b"
            |> Document.delete_field "c" |> Document.data) );
       ]

let test_collection = 
  "test suite for collection"
  >::: [
    
  ]

let _ = run_test_tt_main test_document
