type key = string
(** [key] is the key of our database. Requires: [key] has to be unique in our
    database*)

type value
(** [value] is the value of our databse by querying on the [key]. [value] can be
    of any data types *)

type t
(** [t] is the representation of the document. *)

val empty : string -> t
(** [empty id] is a document with id of [id]. ) *)

val set_data : (key * value) list -> t -> t
(** overwrite a document (only retain id)*)

val update_data : (key * value) list -> t -> t
(** update a document without overwriting the entire document *)

val delete_field : key -> t -> t
(** delete a field in a document *)

val document_id : t -> string
(** return the id of a document *)

val data : t -> (key * value) list
(** return the data of a document *)

type query =
  | Is_less_than of value
  | Is_less_than_or_equal_to of value
  | Is_equal_to of value
  | Is_greater_than of value
  | Is_greater_than_or_equal_to of value
  | Is_not_equal_to of value
  | Is_in of value list
  | Is_not_in of value list

val where_field : t -> key -> query
