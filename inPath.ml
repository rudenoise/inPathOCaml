open Core.Std

(* TODO:
   * pattern match rather than ifs?
   * use modules?
   * then filter/print results
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

let print_path_list p_list =
  List.iter
    ~f: print_endline
    p_list

let spec =
  let open Command.Spec in
  empty
  +> anon ("path" %: string)

let command =
  Command.basic
    ~summary: "inPath displays all paths beneath the current directory"
    ~readme: (fun () -> "More detailed info")
    spec
    (fun path () ->
       if (Sys.is_directory path) = `Yes then
         print_path_list (read_dir path [])
       else
         eprintf "invalid dir path\n"
    )

let () =
  Command.run ~version:"0.1" ~build_info:"RWO" command
