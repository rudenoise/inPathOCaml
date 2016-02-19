open Core.Std

let spec =
  let open Command.Spec in
  empty
  +> anon ("path" %: string)

let command =
  Command.basic
    ~summary: "inPath displays all paths beneath the current directory"
    ~readme: (fun () -> "More detailed info")
    spec
    (fun path () -> printf "%s\n" path)

let () =
  Command.run ~version:"0.1" ~build_info:"RWO" command
