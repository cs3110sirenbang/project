exception Json_error of string

type key = string
(** Type for the key stored in documents. Document's key is always string. *)

type value = Value.t
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

val string_of_document : ?tabs:int -> t -> string
(** [string_of_document ?tabs document] is a string representation of
    [document]. [?tabs] is an optional argument, which specifies how many tabs
    to prepend each line of the string with. This string representation is a
    JSON string. *)

val to_json : t -> string -> unit
(** [to_json document filename] writes [document] into the file path [filename]
    in JSON format. Example: [to_json doc "doc.json"] *)

val from_json : string -> t
(** [from_json filename] is the document corresponding to JSON string stored in
    the file path [filename]. Raises: [JSON_error] if the JSON string in
    [filename] doesn't have a valid JSON format or correspond to a valid
    document. Details of the spec coming soon... *)

val from_json_string : string -> t
(** [from_json string] is the document corresponding to the JSON string
    [string]. Raises: [JSON_error] if [string] doesn't have a valid JSON format
    or correspond to a valid document. Details of the spec coming soon... *)

val union : t -> t -> t
(** [union doc1 doc2] is the document containing key-value pairs in either
    [doc1] or [doc2]. If two pairs [(k, v1)], [(k, v2)] of the same key are
    present in both [doc1] and [doc2], then [(k, v1)] is stored in the resulting
    document. *)

val intersect : t -> t -> t
(** [union doc1 doc2] is the document containing key-value pairs in both [doc1]
    or [doc2]. *)

val difference : t -> t -> t
(** [difference doc1 doc2] is the document containing key-value pairs in [doc1]
    but not in [doc2]. *)
