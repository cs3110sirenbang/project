open Project

(* Create documents *)
let doc1 =
  Document.(
    make "1"
    |> set_data [ ("name", "Thomas"); ("age", "19"); ("college", "A&S") ])

let doc2 =
  Document.(make "2" |> set_data [ ("name", "Jasmine"); ("college", "ENG") ])

let doc3 =
  Document.(
    make "3"
    |> set_data [ ("name", "Daniel"); ("age", "20"); ("college", "A&S") ])

let doc4 =
  Document.(
    make "4" |> set_data [ ("name", "Steven"); ("age", "19"); ("major", "CS") ])

(* Create collection from these documents*)
let col =
  Collection.(
    make "col" |> set_document doc1 |> set_document doc2 |> set_document doc3
    |> set_document doc4)

(* print collection*)
let () =
  Collection.string_of_collection col |> print_endline;
  print_endline ""

(* Change one of the fields in one of the documents and print the new
   collection*)
let () =
  col
  |> Collection.set_document (Document.update_data [ ("college", "ENG") ] doc1)
  |> Collection.string_of_collection |> print_endline;
  print_endline ""

(* Delete one of the documents and print the new collection*)
let () =
  Collection.(col |> delete doc2 |> string_of_collection |> print_endline);
  print_endline ""

(* Querying: find all students who's 19 years old and in Arts and Sciences and
   print the new collection*)
let () =
  Collection.(
    col
    |> where_field "college" (Is_equal_to "A&S")
    |> where_field "age" (Is_equal_to "19")
    |> string_of_collection |> print_endline);
  print_endline ""
