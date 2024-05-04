exception Invalid_token
(** Error raised when a lexical error occurs in the lexer. TODO: Refine the
    error in later sprints. *)

(** type representing the list of tokens that might appear in a valid JSON
    string. *)
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

val lex_string : string -> token list
(** [lex_string s] converts the JSON string [s] into a list of tokens
    representing [s]. Raises: [Invalid_token] if [s] contains tokens that
    doesn't correspond to valid JSON string. *)

val lex_file : string -> token list
(** [lex_string s] converts the JSON string [s] stored in the file path [f] into
    a list of tokens representing [s].Raises: [Invalid_token] if [s] contains
    tokens that doesn't correspond to valid JSON string. *)
