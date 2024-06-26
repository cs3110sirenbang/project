open OUnit2
open Project

let set_equal s1 s2 =
  List.for_all (fun x -> List.mem x s1) s2
  && List.for_all (fun x -> List.mem x s2) s1

let document_tests =
  "test suite for document"
  >:::
  let empty_doc = Document.make "0" in
  let data =
    [ ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C") ]
  in
  let doc = empty_doc |> Document.set_data data in
  [
    ( "test set_data" >:: fun _ ->
      assert_equal data (doc |> Document.set_data data |> Document.data) );
    ( "test set_data 2" >:: fun _ ->
      assert_equal
        [ ("a", Value.Str "a") ]
        (doc |> Document.set_data [ ("a", Value.Str "a") ] |> Document.data) );
    ( "test set_data 3" >:: fun _ ->
      assert_equal
        [ ("a", Value.Int 1) ]
        (doc |> Document.set_data [ ("a", Value.Int 1) ] |> Document.data) );
    ( "test update_data" >:: fun _ ->
      assert_equal (Value.Str "a")
        (doc
        |> Document.update_data [ ("a", Value.Str "a") ]
        |> Document.data |> List.assoc "a") );
    ( "test update_data 2" >:: fun _ ->
      assert_equal
        [ ("a", Value.Str "A"); ("b", Value.Str "b"); ("c", Value.Str "c") ]
        (doc
        |> Document.update_data [ ("b", Value.Str "b"); ("c", Value.Str "c") ]
        |> Document.data) );
    ( "test update_data 3" >:: fun _ ->
      assert_equal
        [
          ("a", Value.Str "a");
          ("b", Value.Str "B");
          ("c", Value.Str "C");
          ("d", Value.Str "d");
        ]
        (doc
        |> Document.update_data [ ("a", Value.Str "a"); ("d", Value.Str "d") ]
        |> Document.data) );
    ( "test update_data 4" >:: fun _ ->
      assert_equal data (doc |> Document.update_data [] |> Document.data) );
    ( "test update_data 5" >:: fun _ ->
      assert_equal
        [ ("a", Value.Int 1); ("b", Value.Str "B"); ("c", Value.Str "C") ]
        (doc |> Document.update_data [ ("a", Value.Int 1) ] |> Document.data) );
    ( "test update_data 6" >:: fun _ ->
      assert_equal
        [
          ("a", Value.Str "A");
          ("b", Value.Str "B");
          ("c", Value.Str "C");
          ("d", Value.Int 1);
        ]
        (doc |> Document.update_data [ ("d", Value.Int 1) ] |> Document.data) );
    ( "test delete_field" >:: fun _ ->
      assert_equal (List.tl data)
        (doc |> Document.delete_field "a" |> Document.data) );
    ( "test delete_field 2" >:: fun _ ->
      assert_equal []
        (doc |> Document.delete_field "a" |> Document.delete_field "b"
       |> Document.delete_field "c" |> Document.data) );
    ( "test delete_field 3" >:: fun _ ->
      assert_raises Not_found (fun () ->
          doc |> Document.delete_field "a" |> Document.delete_field "b"
          |> Document.delete_field "c" |> Document.delete_field "d"
          |> Document.data) );
    ( "test document_id" >:: fun _ ->
      assert_equal "0" (doc |> Document.document_id) );
    ( "test string_of_document" >:: fun _ ->
      assert_equal
        "{\n\
         \t\"document_id\": \"0\", \n\
         \t\"data\": {\n\
         \t\t\"a\": \"A\", \n\
         \t\t\"b\": \"B\", \n\
         \t\t\"c\": \"C\"\n\
         \t}\n\
         }"
        (doc |> Document.string_of_document) );
    ( "test equals 1" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      assert_bool "must be true" (Document.equals doc1 doc2) );
    ( "test equals 2" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("c", Value.Str "C"); ("b", Value.Str "B"); ("a", Value.Str "A");
             ]
      in
      assert_bool "must be true" (Document.equals doc1 doc2) );
    ( "test equals 3" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data [ ("a", Value.Str "A"); ("b", Value.Str "B") ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("c", Value.Str "C"); ("b", Value.Str "B"); ("a", Value.Str "A");
             ]
      in
      assert_bool "must be false" (not (Document.equals doc1 doc2)) );
    ( "test union 1" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data [ ("a", Value.Str "A"); ("b", Value.Str "B") ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data [ ("b", Value.Str "B"); ("c", Value.Str "C") ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.union doc2)) );
    ( "test union 2" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data [ ("a", Value.Str "A"); ("b", Value.Str "B") ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data [ ("b", Value.Str "B"); ("c", Value.Str "C") ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.union doc2)) );
    ( "test union 3" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data [ ("a", Value.Str "A"); ("b", Value.Str "B") ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data [ ("b", Value.Str "B"); ("c", Value.Str "C") ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      assert_bool "must be true"
        (Document.equals doc3
           (doc1 |> Document.union doc2 |> Document.union doc1)) );
    ( "test union 4" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data [ ("a", Value.Str "A"); ("b", Value.Str "B") ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data [ ("b", Value.Str "B"); ("c", Value.Str "C") ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      assert_bool "must be true"
        (Document.equals doc3
           (doc2 |> Document.union doc1 |> Document.union doc2)) );
    ( "test union 5" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B"); ("c", Value.Str "C"); ("d", Value.Str "D");
             ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A");
               ("b", Value.Str "B");
               ("c", Value.Str "C");
               ("d", Value.Str "D");
             ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.union doc2)) );
    ( "test difference 1" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B"); ("c", Value.Str "C"); ("d", Value.Str "D");
             ]
      in
      let doc3 = empty_doc |> Document.set_data [ ("d", Value.Str "D") ] in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.difference doc2)) );
    ( "test difference 2" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B"); ("c", Value.Str "C"); ("d", Value.Str "D");
             ]
      in
      let doc3 = empty_doc |> Document.set_data [ ("d", Value.Str "D") ] in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.difference doc2)) );
    ( "test difference 3" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("e", Value.Str "E"); ("c", Value.Str "C");
             ]
      in

      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B"); ("c", Value.Str "C"); ("d", Value.Str "D");
             ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data [ ("a", Value.Str "A"); ("e", Value.Str "E") ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc2 |> Document.difference doc1)) );
    ( "test intersect" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B"); ("c", Value.Str "C"); ("d", Value.Str "D");
             ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data [ ("b", Value.Str "B"); ("c", Value.Str "C") ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.intersect doc2)) );
    ( "test intersect 2" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B"); ("c", Value.Str "C"); ("d", Value.Str "D");
             ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data [ ("b", Value.Str "B"); ("c", Value.Str "C") ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc2 |> Document.intersect doc1)) );
    ( "test intersect 3" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A"); ("b", Value.Str "B"); ("c", Value.Str "C");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B"); ("c", Value.Str "C"); ("d", Value.Str "D");
             ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data [ ("b", Value.Str "B"); ("c", Value.Str "C") ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.intersect doc2)) );
    ( "test intersect 4" >:: fun _ ->
      let doc1 =
        empty_doc
        |> Document.set_data
             [
               ("a", Value.Str "A");
               ("b", Value.Str "B");
               ("c", Value.Str "C");
               ("d", Value.Str "D");
               ("f", Value.Str "F");
             ]
      in
      let doc2 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B");
               ("c", Value.Str "C");
               ("d", Value.Str "D");
               ("e", Value.Str "E");
               ("f", Value.Str "F");
             ]
      in
      let doc3 =
        empty_doc
        |> Document.set_data
             [
               ("b", Value.Str "B");
               ("c", Value.Str "C");
               ("d", Value.Str "D");
               ("f", Value.Str "F");
             ]
      in
      assert_bool "must be true"
        (Document.equals doc3 (doc1 |> Document.intersect doc2)) );
  ]
