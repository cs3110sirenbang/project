type key = string
(** Type for the key stored in documents. *)

type value = string
(** Type for the values stored in documents. *)

type t
(** The representation type of the document. A document is a map-like structure
    storing key-value pairs. The list of keys in the document are referred to as
    the fields of the document. *)

val make : string -> t
(** [make id] is a document with id [id] and no fields and values. *)

val set_data : (key * value) list -> t -> t
(** [set_data pairs document] is the document containing only key-value pairs in
    [pairs] but with the same id as [document]. If [document] does not exist, it
    will be created; otherwise, the contents of [document] will be overwritten
    with [pairs]. Example: [set_data [("a", "algeria")] (make "countries")] is a
    document with id [countries] and data [("a", "algeria")]. *)

val update_data : (key * value) list -> t -> t
(** [update_data pairs document] is the document after each value in [document]
    corresponding to some field in [pairs] has been replaced by the
    corresponding value in [pairs]. If there exists a field in [pairs] that does
    not exist in document, the key value pair is added to [document]. The fields
    in [pairs] in [document] will be updated without overwriting all of
    [document]. *)

val delete_field : key -> t -> t
(** [delete_field key document] is the document after the field [key] has been
    removed in [document]. Raises: [Not_found] if [key] is not a field. *)

val document_id : t -> string
(** [document_id document] is the id of [document]. *)

val data : t -> (key * value) list
(** [data document] is a list of key-value pairs stored in [document]. *)

val string_of_document : t -> string
(** [string_of_document document] is a string representation of [document]*)
