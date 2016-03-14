open Core.Std

(* TODO:
   * use optional check for print
   * make a generic include/exclude RE tuple
   * add tuple to a list (if present/not none)
   * fold the paths list against the tuples
   * swap core for a targeted sub-set of libraries
*)


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
    (fun inc_re exc_re path () ->
       if (Sys.is_directory path) = `Yes then
         Path.print_path_list
           ~include_re:inc_re
           ~exclude_re:exc_re
           ~paths_list:(Path.read_dir ~path:path ~paths_list:[])
       else
         eprintf "invalid dir path\n"
    )

let () =
  Command.run ~version:"0.1" ~build_info:"github.com/rudenoise/inPathOCaml" command
