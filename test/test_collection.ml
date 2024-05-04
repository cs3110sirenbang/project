open OUnit2
open Project

let set_equal s1 s2 =
  List.for_all (fun x -> List.mem x s1) s2
  && List.for_all (fun x -> List.mem x s2) s1

let collection_tests =
  "test suite for collection"
  >:::
  let doc0 =
    Document.(
      make "0"
      |> set_data
           [
             ("a", Value.Str "a0"); ("b", Value.Str "b0"); ("c", Value.Str "c0");
           ])
  in
  let doc1 =
    Document.(
      make "1"
      |> set_data
           [
             ("a", Value.Str "a1"); ("b", Value.Str "b1"); ("c", Value.Str "c1");
           ])
  in
  let doc2 =
    Document.(
      make "2"
      |> set_data
           [
             ("a", Value.Str "a2"); ("b", Value.Str "b2"); ("c", Value.Str "c2");
           ])
  in
  let doc3 =
    Document.(
      make "2"
      |> set_data
           [
             ("a", Value.Str "a3"); ("b", Value.Str "b3"); ("c", Value.Str "c3");
           ])
  in
  let col =
    Collection.(
      make "Collection" |> set_document doc0 |> set_document doc1
      |> set_document doc2)
  in
  [
    ( "test get_document 1" >:: fun _ ->
      assert_equal (Value.Str "c0")
        (col |> Collection.get_document "0" |> Document.data |> List.assoc "c")
    );
    ( "test get_document 2" >:: fun _ ->
      assert_equal (Value.Str "a2")
        (col |> Collection.get_document "2" |> Document.data |> List.assoc "a")
    );
    ( "test get_document 3" >:: fun _ ->
      assert_raises Not_found (fun _ -> col |> Collection.get_document "114514")
    );
    ( "test set_document" >:: fun _ ->
      assert_equal (Value.Str "c3")
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
    ( "test where_field (equal_to)" >:: fun _ ->
      assert_bool "fails"
        (set_equal [ doc0 ]
           (col
           |> Collection.where_field "a" (Is_equal_to (Value.Str "a0"))
           |> Collection.get_documents)) );
    ( "test where_field (not_equal_to)" >:: fun _ ->
      assert_bool "fails"
        (set_equal [ doc0; doc2 ]
           (col
           |> Collection.where_field "b" (Is_not_equal_to (Value.Str "b1"))
           |> Collection.get_documents)) );
    ( "test where_field (in/is_not_in)" >:: fun _ ->
      assert_bool "fails"
        (set_equal
           (col
           |> Collection.where_field "c" (Is_not_in [ Value.Str "c0" ])
           |> Collection.get_documents)
           (col
           |> Collection.where_field "c"
                (Is_in [ Value.Str "c2"; Value.Str "c1" ])
           |> Collection.get_documents)) );
  ]
