type key = string
(** Type for the key stored in documents. *)

type value
(** Type for the values stored in documents. *)

type t
(** The representation type of the document. A document is a map-like structure
    storing key-value pairs. *)

val set_data : (key * value) list -> t -> t
(** [set_data pairs document] is the document containing only key-value pairs in
    [pairs] but with the same id as [document]. *)

val update_data : (key * value) list -> t -> t
(** [update_data pairs document] is the document after the each value in
    [document] for some key in [pairs] has been replaced by the corresponding
    value in [pairs]. Raises: [Not_found] If [pairs] contains some keys that
    can't be found in [document],*)

val delete_field : key -> t -> t
(** [delete_field key document] is the document after the key [key] has been
    removed in [dcoument]. *)

val document_id : t -> string
(** [document_id document] is the id of [document]. *)

val data : t -> (key * value) list
(** [data document] is a list of key-value pairs stored in [document]. *)

val string_of_document : t -> string
(** [string_of_document document] is a string representation of [document]*)
