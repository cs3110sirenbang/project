open Document

type t
(** representation type for a Collection. A Collection is an unordered
    collection of documents ([Document.t]). *)

val make : string -> t
(** [make name] is a new collection with name [name] and no documents. *)

val get_document : string -> t -> Document.t
(** [get_document id collection] is the document with id [id] in [collection].
    Raises [Not_Found] if there exists no document with id [id]. *)

val set_document : Document.t -> t -> t
(** [set_document doc collection] is the collection with document [doc] in
    [collection]. If a document with id [document_id doc] already existed in
    [collection], it will be overwritten. *)

(** The variant type representing a query criteria. The meaning of each of these
    criteria should be obvious. *)
type query =
  | Is_less_than of value
  | Is_less_than_or_equal_to of value
  | Is_equal_to of value
  | Is_greater_than of value
  | Is_greater_than_or_equal_to of value
  | Is_not_equal_to of value
  | Is_in of value list
  | Is_not_in of value list

val where_field : string -> query -> t -> t
(** [where_field field query collection] is a collection of all documents in
    [collection] who has the field [field] and whose values of the field named
    [field] satisfies the criteria [query]. *)

val delete : Document.t -> t -> t
(** [delete document collection] is the collection after [document] has been
    removed from [collection]. If the [document] does not exist in [collection],
    [collection] is returned with no changes. *)

val get_name : t -> string
(** [get_name collection] is the name of [collection]. *)

val get_documents : t -> Document.t list
(** [get_documents collection] is a list of documents contained in [collection]. *)

val string_of_collection : t -> string
(** [string_of_collection collection] is a string representation of
    [collection]. *)

val to_json : t -> string -> unit
(** [to_json col filename] writes [col] into the file path [filename] in JSON
    format. Example: [to_json col "col.json"] *)
