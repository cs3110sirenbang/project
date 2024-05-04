open OUnit2
open Project 
open Lexer
open Parser
open Value

let lex_tests =
  let test_atom atoms strs _ =
    List.iter2 (fun atom s -> assert_equal [ atom ] (lex_string s)) atoms strs
  in
  let test lex lst s _ = assert_equal lst (lex s) in
  let test_error s _ = assert_raises Invalid_token (fun _ -> lex_string s) in
  let strs =
    [ "103948"; "-1.10834"; "true"; "\"apple\""; ":"; "["; "]"; "{"; "}"; "," ]
  in
  let atoms =
    [
      INT 103948;
      FLOAT (-1.10834);
      BOOL true;
      STR "apple";
      COLON;
      LBRACKET;
      RBRACKET;
      LBRACE;
      RBRACE;
      COMMA;
    ]
  in
  let data =
    "{\"A\" : 1, \"Banana\" : false, \"Cherry\":  [1,true,1.1,\"Duck\"]}"
  in
  let tokens =
    [
      LBRACE;
      STR "A";
      COLON;
      INT 1;
      COMMA;
      STR "Banana";
      COLON;
      BOOL false;
      COMMA;
      STR "Cherry";
      COLON;
      LBRACKET;
      INT 1;
      COMMA;
      BOOL true;
      COMMA;
      FLOAT 1.1;
      COMMA;
      STR "Duck";
      RBRACKET;
      RBRACE;
    ]
  in
  "tests for lexer"
  >::: [
         ( "empty string creates no tokens" >:: fun _ ->
           assert_equal [] (lex_string "") );
         "atoms" >:: test_atom atoms strs;
         "single-line lexing" >:: test lex_string tokens data;
         "multi-line lexing" >:: test lex_file tokens "data0.json";
         "invalid token #1" >:: test_error "abcde";
         "invalid token #2" >:: test_error "{\"A\";\"B!\"}";
         "invalid token #3" >:: test_error "{\"A\":1.3ac8e}";
       ]

let parser_tests =
  "tests for parser"
  >::: [
         (let test_error s _ =
            assert_raises Syntax_error (fun _ -> parse_string s)
          in
          let equal_contents a b =
            match (a, b) with
            | Map m1, Map m2 ->
                List.sort Stdlib.compare (TMap.bindings m1)
                = List.sort Stdlib.compare (TMap.bindings m2)
            | _, _ -> failwith "Impossible branch -- equal_contents"
          in
          let test v s _ =
            assert_bool "test" (equal_contents v (parse_string s))
          in
          let test_file v s _ = assert_equal v (parse_file s) in
          let test_atom atoms strs _ =
            List.iter2
              (fun v s ->
                assert_bool "test_equal"
                  (equal_contents
                     (Map (TMap.empty |> TMap.add "A" v))
                     (parse_string ("{\"A\":" ^ s ^ "}"))))
              atoms strs
          in
          let atoms = [ Int 1; Str "Duck"; Float 1.1; Bool true; Bool false ] in
          let strs = [ "1"; "\"Duck\""; "1.1"; "true"; "false" ] in
          let small_maps = "{\"A\":1,\"B\":true,\"C\":\"apple\",\"D\":1.0}" in
          let small_map =
            Map
              TMap.(
                empty |> add "A" (Int 1) |> add "B" (Bool true)
                |> add "C" (Str "apple") |> add "D" (Float 1.0))
          in
          let map_with_lists = "{\"A\":[1,true,1.1,\"apple\"]}" in
          let map_with_list =
            Map
              (TMap.empty
              |> TMap.add "A"
                   (List [ Int 1; Bool true; Float 1.1; Str "apple" ]))
          in
          let nested_map =
            Map
              TMap.(
                empty
                |> add "A"
                     (List
                        [
                          Map
                            (empty
                            |> add "B"
                                 (List [ Map (empty |> add "D" (List [])) ]));
                          Map
                            (empty
                            |> add "C"
                                 (List [ Map (empty |> add "E" (List [])) ]));
                        ]))
          in
          "tests for parser"
          >::: [
                 "empty string raises error" >:: test_error "";
                 "atoms" >:: test_atom atoms strs;
                 "empty map" >:: test (Map TMap.empty) "{}";
                 "small map" >:: test small_map small_maps;
                 "map_with_list" >:: test map_with_list map_with_lists;
                 "nested map" >:: test_file nested_map "data1.json";
                 ( "real world dataset" >:: fun _ ->
                   ignore (parse_file "data2.json") );
                 "syntax error: no matching right bracket"
                 >:: test_error "{\"A\":1,\"B\", ";
                 "syntax error: non-string types as keys"
                 >:: test_error "{[1,2,3]:1,\"B\":2}";
                 "syntax error: redundant bracket" >:: test_error "{{\"A\":1}}";
                 "syntax error: a more complex example"
                 >:: test_error "{\"A\":1,{\"A\":2,,\"B\":{\"3\":12345999}}";
               ]);
       ]