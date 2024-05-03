exception Type_error

module TMap : Map.S with type key = string
(** a [Map.S] module containing representation type for CamlStore maps. *)

(** Representation type for values contained in a document (a.k.a. CamlStore
    values). A value can be: 1. a string,

    2. an integer,

    3. a float,

    4. a boolean,

    5. a heterogenous list of values

    6. a heterogenous map (stored as a built-in [TMap.t]) with strings as keys.

    The type of a CamlStore value refers to the type of the primitive value
    stored in this value. *)
type t =
  | Str of string
  | Int of int
  | Float of float
  | Bool of bool
  | List of t list
  | Map of t TMap.t

val make_strings : string list -> t list
(** [make_strings lst] is a CamlStore list with CamlStore strings given in
    [lst]. *)

val make_ints : int list -> t list
(** [make_ints lst] is a CamlStore list with CamlStore integers given in
    [lst]. *)

val make_floats : float list -> t list
(** [make_floats lst] is a CamlStore list with CamlStore floats given in [lst]. *)

val make_bools : bool list -> t list
(** [make_bools lst] is a CamlStore list with CamlStore booleans given in
    [lst]. *)

val make_lists : t list -> t list
(** [make_lists lst] is a CamlStore list with CamlStore strings given in
    [lst]. *)

val make_map : t TMap.t -> t
(** [make_map map] is a CamlStore map given the Ocaml map [map]. *)

val string_of_value : t -> string
(** [string_of_value value] is a string representation of the CamlStore value
    [value]*)

val compare : t -> t -> int
(** [compare v1 v2] is the result of comparing CamlStore values [v1] and [v2]:
    1. If [v1] and [v2] are of different types, then a [Type_error] is raised.

    2. If [v1] and [v2] are equal, then [0] is returned.

    3. If [v1] and [v2] are not equal, then [-2] is returned.

    4. If [v1] is less than [v2], then [-1] is returned.

    5. If [v1] is greater than [v1], then [1] is returned.

    If [v1] and [v2] are lists or maps, then the branches (1), (2) and (3) are
    executed. Otherwise, the branches (1), (2), (4), and (5) are executed
    instead. *)

val int_of_value : t -> int
(** [int_of_value v] is the built-in integer corresponding to the CamlStore
    value [v]. If [v] is not an integer, then a [Type_error] is raised. *)

val float_of_value : t -> float
(** [float_of_value v] is the built-in integer corresponding to the CamlStore
    value [v]. If [v] is not an integer, then a [Type_error] is raised. *)

val bool_of_value : t -> bool
(** [bool_of_value v] is the built-in boolean corresponding to the CamlStore
    value [v]. If [v] is not an integer, then a [Type_error] is raised. *)

val list_of_value : t -> t list
(** [list_of_value v] is the built-in list corresponding to the CamlStore value
    [v]. If [v] is not an integer, then a [Type_error] is raised. *)

val map_of_value : t -> t TMap.t
(** [map_of_value v] is the built-in map corresponding to the CamlStore value
    [v]. If [v] is not an integer, then a [Type_error] is raised. *)

val in_int : (int -> 'a) -> t -> 'a
(** [in_int f] transforms a function [f] taking an built-in integer as parameter
    to a function that takes a CamlStore integer as parameter. *)

val in_float : (float -> 'a) -> t -> 'a
(** [in_float f] transforms a function [f] taking an built-in integer as
    parameter to a function that takes a CamlStore integer as parameter. *)

val in_bool : (bool -> 'a) -> t -> 'a
(** [in_bool f] transforms a function [f] taking an built-in boolean as
    parameter to a function that takes a CamlStore boolean as parameter. *)

val in_string : (string -> 'a) -> t -> 'a
(** [in_string f] transforms a function [f] taking an built-in string as
    parameter to a function that takes a CamlStore string as parameter. *)

val out_int : ('a -> int) -> 'a -> t
(** [out_int f] transforms a function [f] returning a built-in integer to a
    function returning a CamlStore integer. *)

val out_float : (float -> 'a) -> t -> 'a
(** [out_float f] transforms a function [f] returning a built-in float to a
    function returning a CamlStore float. *)

val out_bool : (bool -> 'a) -> t -> 'a
(** [out_bool f] transforms a function [f] returning a built-in boolean to a
    function returning a CamlStore boolean. *)

val out_string : (string -> 'a) -> t -> 'a
(** [out_string f] transforms a function [f] returning a built-in string to a
    function returning a CamlStore string. *)
