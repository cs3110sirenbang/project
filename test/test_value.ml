open OUnit2
open Project
open Value

let test_make_strings _ =
  let empty = make_strings [] in
  let non_empty = make_strings [ "hello"; "world" ] in
  assert_equal [] empty;
  assert_equal [ Str "hello"; Str "world" ] non_empty

let test_make_ints _ =
  let empty = make_ints [] in
  let non_empty = make_ints [ 1; 2 ] in
  assert_equal [] empty;
  assert_equal [ Int 1; Int 2 ] non_empty

let test_make_floats _ =
  let empty = make_floats [] in
  let non_empty = make_floats [ 1.0; 2.0 ] in
  assert_equal [] empty;
  assert_equal [ Float 1.0; Float 2.0 ] non_empty

let test_make_bools _ =
  let empty = make_bools [] in
  let non_empty = make_bools [ true; false ] in
  assert_equal [] empty;
  assert_equal [ Bool true; Bool false ] non_empty

let test_string_of_value_compare _ =
  let str = Str "hello" in
  let int = Int 1 in
  let float = Float 1.0 in
  let bool = Bool true in
  let list = List [ str; int; float; bool ] in
  let map = TMap.empty |> TMap.add "key" (Int 42) in
  assert_equal "hello" (string_of_value str);
  assert_equal "1" (string_of_value int);
  assert_equal "1." (string_of_value float);
  assert_equal "true" (string_of_value bool);
  assert_equal "[hello, 1, 1., true]" (string_of_value list);
  assert_equal "{ key: 42 }" (string_of_value (Map map))

let test_compare _ =
  assert_equal 0 (compare (Int 42) (Int 42));
  assert_equal (-1) (compare (Int 41) (Int 42));
  assert_equal 0 (compare (Str "hello") (Str "hello"));
  assert_equal (-1) (compare (Str "hello") (Str "world"));
  assert_equal 0 (compare (Float 3.0) (Float 3.0));
  assert_equal (-1) (compare (Float 2.0) (Float 3.0));
  assert_equal 0 (compare (Bool true) (Bool true));
  assert_equal (-1) (compare (Bool false) (Bool true));
  assert_equal 0
    (compare
       (List [ Float 1.0; Int 2; Str "hi" ])
       (List [ Float 1.0; Int 2; Str "hi" ]));
  assert_equal (-2)
    (compare
       (List [ Float 3.0; Int 2; Str "hi" ])
       (List [ Float 1.0; Int 2; Str "hi" ]));
  assert_equal (-2)
    (compare
       (List [ Float 1.0; Int 2; Str "hi" ])
       (List [ Float 1.0; Int 2; Str "hello" ]));
  assert_equal 0
    (compare
       (Map (TMap.empty |> TMap.add "key" (Int 42)))
       (Map (TMap.empty |> TMap.add "key" (Int 42))));
  assert_equal (-2)
    (compare
       (Map (TMap.empty |> TMap.add "key" (Int 42)))
       (Map (TMap.empty |> TMap.add "key" (Int 41))));
  assert_raises Type_error (fun () -> compare (Int 42) (Str "hello"));
  assert_raises Type_error (fun () -> compare (Int 42) (Bool true));
  assert_raises Type_error (fun () -> compare (Float 3.0) (Bool true));
  assert_raises Type_error (fun () -> compare (Float 3.0) (Str "hello"));
  assert_raises Type_error (fun () ->
      compare (List [ Float 3.0; Int 2; Str "hi" ]) (Str "hello"))

let test_type_conversions _ =
  assert_equal 42 (int_of_value (Int 42));
  assert_raises Type_error (fun () -> int_of_value (Bool true));
  assert_equal 42.0 (float_of_value (Float 42.0));
  assert_raises Type_error (fun () -> float_of_value (Int 42));
  assert_equal true (bool_of_value (Bool true));
  assert_raises Type_error (fun () -> bool_of_value (Int 42));
  assert_equal [ Int 42; Bool true ]
    (list_of_value (List [ Int 42; Bool true ]));
  assert_raises Type_error (fun () -> list_of_value (Int 42));
  let map = TMap.empty |> TMap.add "key" (Int 42) in
  assert_equal map (map_of_value (Map map));
  assert_raises Type_error (fun () -> map_of_value (Int 42))

let value_tests =
  "test suite for value"
  >::: [
         "test_make_strings" >:: test_make_strings;
         "test_make_ints" >:: test_make_ints;
         "test_make_floats" >:: test_make_floats;
         "test_make_bools" >:: test_make_bools;
         "test_string_of_value" >:: test_string_of_value_compare;
         "test_type_conversions" >:: test_type_conversions;
       ]
