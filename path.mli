open Core.Std

(** collect paths in a directory and recurse sub-directories*)

val read_dir : path:string -> paths_list:string list -> string list

(** print a list of strings/paths *)

val print_path_list : include_re:string -> exclude_re:string -> paths_list:string list -> unit
