open Document

type t
(** representation type for a Collection. A Collection is an unordered
    collection of documents ([Document.t]). *)

val make : string -> t
(** [make name] is a new collection with name [name] and no documents. *)

val document : string -> t -> Document.t * t
(** [document id collection] is the document with id [id] in [collection] if
    [id] exists in [collection] or an empty document with id [id] with no keys
    and data *)

type query =
(** The variant type representing a query criteria. The meaning of each of 
    these criteria should be obvious. *)
  | Is_less_than of value
  | Is_less_than_or_equal_to of value
  | Is_equal_to of value
  | Is_greater_than of value
  | Is_greater_than_or_equal_to of value
  | Is_not_equal_to of value
  | Is_in of value list
  | Is_not_in of value list

val where_field : string -> query -> t -> t
(** [where_field field query value] is a collection of all documents whose
    values of the field named [field] satisfies the criteria [query]. *)

val delete : Document.t -> t -> t
(** [delete document collection] is the Collection after [document] has been
    removed from [collection]. Raises: [Not_found] if [document] doesn't exist
    in [collection]. *)

val get_documents : t -> Document.t list
(** [get_documents collection] is a list of documents contained in [collection]*)

val string_of_collection : t -> string
(** [string_of_collection collection] is a string representation of [collection]*)
