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
    ("test set_data" >:: fun _ -> assert_equal data (doc |> Document.data));
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
    ( "test delete_field" >:: fun _ ->
      assert_equal (List.tl data)
        (doc |> Document.delete_field "a" |> Document.data) );
    ( "test delete_field 2" >:: fun _ ->
      assert_equal []
        (doc |> Document.delete_field "a" |> Document.delete_field "b"
       |> Document.delete_field "c" |> Document.data) );
  ]
