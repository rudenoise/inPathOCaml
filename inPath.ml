open Core.Std

(* TODO:
   * pattern match rather than ifs?
   * use modules?
   * use optional check for print
*)

let rec read_dir path paths_list =
  let children = Sys.readdir path
  in
  Array.fold
    ~init: paths_list
    ~f:(fun p_list child ->
        let full_path = if path = "./" then
            path ^ child
          else
            path ^ "/" ^ child
        in
        if (Sys.is_directory full_path) = `Yes then
          (full_path ^ "/") :: (read_dir full_path p_list)
        else
          full_path :: p_list
      )
    children

let print_path_list match_re p_list =
  List.iter
    ~f: (fun line ->
        if Str.string_match (Str.regexp match_re) line 0
        then print_endline (Str.replace_first (Str.regexp "\\/\\/") "/" line)
    )
    p_list

let spec =
  let open Command.Spec in
  empty
  +> flag "-i" (optional_with_default "." string)
    ~doc:"include paths matching Regular Expression"
  +> anon ("path" %: string)

let command =
  Command.basic
    ~summary: "inPath displays all paths beneath the current directory"
    ~readme: (fun () -> "More detailed info")
    spec
    (fun match_re path () ->
       if (Sys.is_directory path) = `Yes then
         print_path_list match_re (read_dir path [])
       else
         eprintf "invalid dir path\n"
    )

let () =
  Command.run ~version:"0.1" ~build_info:"RWO" command
