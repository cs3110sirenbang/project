open Value

exception Syntax_error
(** Error raised when a syntax error occurs in the parser. TODO: Refine the
    error in later sprints. *)

val parse_string : string -> t
(** [parse_string s] is a Camlstore map that's equivalent with the JSON string
    [s]. Consult [syntax.txt] for syntax of a valid JSON string. Raises:
    [Syntax_error] if [s] doesn't correspond to a valid JSON string. *)

val parse_file : string -> t
(** [parse_string s] is a Camlstore map that's equivalent with the JSON string
    [s] stored in the file path [s]. Consult [syntax.txt] for syntax of a valid
    JSON string. Raises: [Syntax_error] if [s] doesn't correspond to a valid
    JSON string. *)
