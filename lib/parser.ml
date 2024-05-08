open Lexer
open Value

exception Syntax_error

type context = {
  tokens : token array;
  mutable p : int;
}

let init (tokens : token list) = { tokens = Array.of_list tokens; p = 0 }

let read context =
  if context.p = Array.length context.tokens then raise Syntax_error
  else
    let token = context.tokens.(context.p) in
    context.p <- context.p + 1;
    token

let peek context =
  if context.p = Array.length context.tokens then raise Syntax_error
  else context.tokens.(context.p)

let rec value context =
  (* print_endline "value"; *)
  match peek context with
  | LBRACE -> map context
  | LBRACKET -> list context
  | _ -> primitive context

and list context =
  (* print_endline "list"; *)
  symbol LBRACKET context;
  let l = values context in
  symbol RBRACKET context;
  l

and map context =
  (* print_endline "map"; *)
  symbol LBRACE context;
  let m = pairs context in
  symbol RBRACE context;
  m

and symbol s context =
  (* print_endline "symbol"; *)
  match read context with
  | x when x = s -> ()
  | _ -> raise Syntax_error

and primitive context =
  (* print_endline "primitive"; *)
  match read context with
  | INT x -> Int x
  | FLOAT x -> Float x
  | STR x -> Str x
  | BOOL x -> Bool x
  | _ -> raise Syntax_error

and values context =
  (* print_endline "values"; *)
  match peek context with
  | RBRACKET -> List []
  | _ -> (
      let h = value context in
      match peek context with
      | COMMA -> (
          symbol COMMA context;
          match values context with
          | List t -> List (h :: t)
          | _ -> failwith "Impossible Branch -- values")
      | _ -> List (h :: []))

and pairs context =
  (* print_endline "pairs"; *)
  match peek context with
  | RBRACE -> Map TMap.empty
  | _ -> (
      let key, value = pair context in
      match peek context with
      | COMMA -> (
          symbol COMMA context;
          match pairs context with
          | Map m -> Map (TMap.add key value m)
          | _ -> failwith "Impossible Branch -- pairs")
      | _ -> Map (TMap.add key value TMap.empty))

and pair context =
  (* print_endline "pair"; *)
  let k = str context in
  symbol COLON context;
  let v = value context in
  (k, v)

and str context =
  (* print_endline "str"; *)
  match read context with
  | STR x -> x
  | _ -> raise Syntax_error

let parse_string string =
  let parser = string |> Lexer.lex_string |> init in
  let value = map parser in
  if parser.p <> Array.length parser.tokens then raise Syntax_error else value

let parse_file string =
  let parser = string |> Lexer.lex_file |> init in
  let value = map parser in
  if parser.p <> Array.length parser.tokens then raise Syntax_error else value
