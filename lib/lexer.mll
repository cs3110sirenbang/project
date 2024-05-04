{
  exception Invalid_token

  type token = 
  | INT of int 
  | STR of string 
  | FLOAT of float 
  | BOOL of bool 
  | LBRACE 
  | RBRACE 
  | LBRACKET 
  | RBRACKET 
  | COMMA 
  | COLON 
}

let digit = ['0'-'9']

rule json = parse 
| ['+' '-']? digit+ as i 
  { INT (int_of_string i) }
| ['+' '-']? digit+ '.' digit* as f 
  { FLOAT (float_of_string f) }
| '\"' (_ # '\"')* '\"' as s 
  { STR (String.sub s 1 (String.length s - 2))}
| "true" | "false" as b
 { BOOL (bool_of_string b) }
| [' ' '\t' '\n']	
  { json lexbuf }
| '{' 
  { LBRACE }
| '}' 
  { RBRACE }
| '[' 
  { LBRACKET }
| ']' 
  { RBRACKET }
| ',' 
  { COMMA }
| ':' 
  { COLON }
| eof 
  { raise End_of_file }

{

  let rec lex lexbuf =
     try 
     (
      let token = json lexbuf in 
      token :: (lex lexbuf)
     )
     with 
     | End_of_file -> []
     | (Failure _) -> raise Invalid_token

  let lex_string str = str |> Lexing.from_string |> lex 
    
  let lex_file file = 
  file |> In_channel.open_text |> Lexing.from_channel |> lex 
}