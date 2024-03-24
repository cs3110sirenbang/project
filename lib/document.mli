type key = string
(** Type for the key stored in documents *)

type value
(** Type for the values stored in documents *)

type t
(** The representation of the document. A document is a map-like structure
    storing key-value pairs. *)

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

val string_of_document : t -> string
(** return string representation of document*)
