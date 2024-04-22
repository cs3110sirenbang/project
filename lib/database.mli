type t
(** Representation type for a Database. A Database is a collection of documents
    ([Document.t]). *)

val read : string -> t
(** [read filename] is the database stored in file [filename]. If [filename] is
    not a valid .cs file, then it raises [Not_found]. *)

val write : string -> t -> unit
(** [write filename db] stores [db] into the file [filename]. If [filename]
    exists, [filename] will be overwritten with [db]. If [filename] doesn't
    exist, [filename] will be created with [db]. *)

val make : string -> t
(** [make name] is a an empty database, with name [name]. *)

val get_collection : string -> t -> Collection.t
(** [get_collection colname db] is the collection with name [colname] in [db].
    If there is no collection with name [colname] in [db], then it raises
    [Not_found]. *)

val set_collection : Collection.t -> t -> unit
(** [set_collection col db] mutates [db] to store [col] in [db]. If there is
    already a collection inside [db] with the same name as [col], it is
    overwritten by [col]. Otherwise, [col] is added to [db]. *)

val delete_collection : Collection.t -> t -> unit
(** [delete_collection col db] mutates [db] to remove [col] from [db]. If [db]
    does not contain [col], then it does nothing. *)
