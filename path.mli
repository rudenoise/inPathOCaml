open Core.Std

(** collect paths in a directory and recurse sub-directories*)

val read_dir : string -> string list -> string list

(** print a list of strings/paths *)

val print_path_list : string -> string -> string list -> unit
