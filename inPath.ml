open Core.Std

let is_dir path =
  if (Sys.is_directory path) = `Yes then
    true
  else
    false

let rec read_dir path =
  let children = Sys.readdir path
  in
  Array.iter
    ~f:(fun child ->
        let full_path = if path = "./" then
            path ^ child
          else
            path ^ "/" ^ child
        in
        if is_dir full_path then
          read_dir full_path
        else
          print_endline full_path
      )
    children

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
       if is_dir path then
         read_dir path
       else
         eprintf "invalid dir path\n"
    )

let () =
  Command.run ~version:"0.1" ~build_info:"RWO" command
