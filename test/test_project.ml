open OUnit2
open Project

let set_equal s1 s2 =
  List.for_all (fun x -> List.mem x s1) s2
  && List.for_all (fun x -> List.mem x s2) s1

let test_document =
  "test suite for document"
  >:::
  let empty_doc = Document.make "0" in
  let data = [ ("a", "A"); ("b", "B"); ("c", "C") ] in
  let doc = empty_doc |> Document.set_data data in
  [
    ("test set_data" >:: fun _ -> assert_equal data (doc |> Document.data));
    ( "test update_data" >:: fun _ ->
      assert_equal "a"
        (doc
        |> Document.update_data [ ("a", "a") ]
        |> Document.data |> List.assoc "a") );
    ( "test update_data 2" >:: fun _ ->
      assert_equal
        [ ("a", "A"); ("b", "b"); ("c", "c") ]
        (doc |> Document.update_data [ ("b", "b"); ("c", "c") ] |> Document.data)
    );
    ( "test update_data 3" >:: fun _ ->
      assert_equal [ ("a", "a"); ("b", "B"); ("c", "C"); ("d", "d") ] (
          doc
          |> Document.update_data [ ("a", "a"); ("d", "d") ]
          |> Document.data) );
    ( "test delete_field" >:: fun _ ->
      assert_equal (List.tl data)
        (doc |> Document.delete_field "a" |> Document.data) );
    ( "test delete_field 2" >:: fun _ ->
      assert_equal []
        (doc |> Document.delete_field "a" |> Document.delete_field "b"
       |> Document.delete_field "c" |> Document.data) );
  ]

let test_collection =
  "test suite for collection"
  >:::
  let doc0 =
    Document.(make "0" |> set_data [ ("a", "a0"); ("b", "b0"); ("c", "c0") ])
  in
  let doc1 =
    Document.(make "1" |> set_data [ ("a", "a1"); ("b", "b1"); ("c", "c1") ])
  in
  let doc2 =
    Document.(make "2" |> set_data [ ("a", "a2"); ("b", "b2"); ("c", "c2") ])
  in
  let doc3 =
    Document.(make "2" |> set_data [ ("a", "a3"); ("b", "b3"); ("c", "c3") ])
  in
  let col =
    Collection.(
      make "Collection" |> set_document doc0 |> set_document doc1
      |> set_document doc2)
  in
  [
    ( "test get_document 1" >:: fun _ ->
      assert_equal "c0"
        (col |> Collection.get_document "0" |> Document.data |> List.assoc "c")
    );
    ( "test get_document 2" >:: fun _ ->
      assert_equal "a2"
        (col |> Collection.get_document "2" |> Document.data |> List.assoc "a")
    );
    ( "test get_document 3" >:: fun _ ->
      assert_raises Not_found (fun _ -> col |> Collection.get_document "114514")
    );
    ( "test set_document" >:: fun _ ->
      assert_equal "c3"
        (col
        |> Collection.set_document doc3
        |> Collection.get_document "2"
        |> Document.data |> List.assoc "c") );
    ( "test get_documents" >:: fun _ ->
      assert_bool "fails"
        (set_equal [ doc0; doc1; doc2 ] (Collection.get_documents col)) );
    ( "test delete 1" >:: fun _ ->
      assert_bool "fails"
        (set_equal [ doc0; doc1 ]
           (col |> Collection.delete doc2 |> Collection.get_documents)) );
    ( "test delete 2" >:: fun _ ->
      assert_raises Not_found (fun _ -> col |> Collection.delete doc3) );
    ( "test where_field (equal_to)" >:: fun _ ->
      assert_bool "fails"
        (set_equal [ doc0 ]
           (col
           |> Collection.where_field "a" (Is_equal_to "a0")
           |> Collection.get_documents)) );
    ( "test where_field (not_equal_to)" >:: fun _ ->
      assert_bool "fails"
        (set_equal [ doc1; doc3 ]
           (col
           |> Collection.where_field "b" (Is_not_equal_to "b1")
           |> Collection.get_documents)) );
    ( "test where_field (in/is_not_in)" >:: fun _ ->
      assert_bool "fails"
        (set_equal
           (col
           |> Collection.where_field "c" (Is_not_in [ "c0"])
           |> Collection.get_documents)
           (col
           |> Collection.where_field "c" (Is_in [ "c2"; "c1" ])
           |> Collection.get_documents)) );
  ]

let _ = run_test_tt_main test_document
let _ = run_test_tt_main test_collection
