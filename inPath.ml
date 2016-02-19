open Core.Std

let read_dir path =
  let children = Sys.readdir path
  in
  Array.iter ~f:print_endline children

let spec =
  let open Command.Spec in
  empty
  +> anon ("path" %: string)

let command =
  Command.basic
    ~summary: "inPath displays all paths beneath the current directory"
    ~readme: (fun () -> "More detailed info")
    spec
    (fun path () -> read_dir path)

let () =
  Command.run ~version:"0.1" ~build_info:"RWO" command
