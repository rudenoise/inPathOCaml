let is_dir path =
  if Sys.is_directory path then
    true
  else
    false

let rec read_dir path =
  let children = Sys.readdir path
  in
  Array.iter
    (fun child ->
        let full_path = if path = "./" then
            path ^ child
          else
            path ^ "/" ^ child
        in
        if is_dir full_path then
          (* TODO:
             * print parent dirs too?
             * pattern match rather than ifs?
             * use modules?
             * collect paths as array in tail call?
             * then filter/print results
          *)
          read_dir full_path
        else
          print_endline full_path
      )
    children

let spec =
  let open Core.Command.Spec in
  empty
  +> anon ("path" %: string)

let command =
  let open Core.Command in
  basic
    ~summary: "inPath displays all paths beneath the current directory"
    ~readme: (fun () -> "More detailed info")
    spec
    (fun path () ->
       if is_dir path then
         read_dir path
       else
         print_endline "invalid dir path\n"
    )

let () =
  let open Core.Command in
  run ~version:"0.1" ~build_info:"RWO" command
