open Core.Std

(* TODO:
   * use modules?
   * use optional check for print
   * make a generic include/exclude RE tuple
   * add tuple to a list (if present/not none)
   * fold the paths list against the tuples
*)

let rec read_dir path paths_list =
  let children = Sys.readdir path
  in
  Array.fold
    ~init: paths_list
    ~f:(fun p_list child ->
        let full_path = match path with
          "./" -> path ^ child
          | _ -> path ^ "/" ^ child
        in
        match (Sys.is_directory full_path) with
          `Yes -> (full_path ^ "/") :: (read_dir full_path p_list)
          | _ -> full_path :: p_list
      )
    children

let print_path_list include_re exclude_re p_list =
  List.iter
    ~f: (fun line ->
        if Str.string_match (Str.regexp include_re) line 0 then begin
          if (Str.string_match (Str.regexp exclude_re) line 0) = false then
            print_endline (Str.replace_first (Str.regexp "\\/\\/") "/" line)
        end
    )
    p_list

let spec =
  let open Command.Spec in
  empty
  +> flag "-i" (optional_with_default "." string)
    ~doc:"include paths matching Regular Expression"
  +> flag "-e" (optional_with_default "\\*" string)
    ~doc:"exclude paths matching Regular Expression"
  +> anon ("path" %: string)

let command =
  Command.basic
    ~summary: "inPath displays all paths beneath the current directory"
    ~readme: (fun () -> "More detailed info")
    spec
    (fun include_re exclude_re path () ->
       if (Sys.is_directory path) = `Yes then
         print_path_list include_re exclude_re (read_dir path [])
       else
         eprintf "invalid dir path\n"
    )

let () =
  Command.run ~version:"0.1" ~build_info:"RWO" command
