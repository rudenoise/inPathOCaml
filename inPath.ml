open Cmdliner

(* TODO:
   * use optional check for print
   * make a generic include/exclude RE tuple
   * add tuple to a list (if present/not none)
   * fold the paths list against the tuples
   * swap core for a targeted sub-set of libraries
*)


let path =
  let doc = "See option $(opt)." in
  let env = Arg.env_var "CMD_PATH" ~doc in
  let doc = "Run the program in directory $(docv)." in
  Arg.(value & opt file Filename.current_dir_name & info ["p"] ~env
         ~docv:"PATH" ~doc)

let inc =
  let doc = "See option $(opt)." in
  let docs = "INCLUDE SECTION" in
  let env = Arg.env_var "CMD_INC" ~doc ~docs in
  let doc = "Whatever this is the doc var $(docv) this is the env var $(env) \
             this is the opt $(opt)."
  in
  Arg.(value & opt string "." & info ["i";] ~env ~docv:"INC" ~doc)

let exc =
  let doc = "See option $(opt)." in
  let docs = "EXCLUDE SECTION" in
  let env = Arg.env_var "CMD_EXC" ~doc ~docs in
  let doc = "Whatever this is the doc var $(docv) this is the env var $(env) \
             this is the opt $(opt)."
  in
  Arg.(value & opt string "\\*" & info ["e";] ~env ~docv:"EXC" ~doc)

let main inc exc path =
  if (Sys.is_directory path) = true then
    Path.print_path_list
      ~include_re:inc
      ~exclude_re:exc
      ~paths_list:(Path.read_dir ~path:path ~paths_list:[])
  else
    Format.printf "invalid dir path: %s\n" path

let man_main =
  Term.(const main $ inc $ exc $ path)

let info =
  let doc = "list all sub-paths matching conditions" in
  let man = [
    `S "THIS IS A SECTION  FOR $(mname)";
    `Noblank;
    `S "ENVIRONMENT VARIABLES"; (* specify where env need to be *)
    `S "BUGS";
    `P "Email bug reports to <rudenoise@gmail.com>.";]
  in
  Term.info "inPath" ~version:"0.0.1" ~doc ~man

let () = match Term.eval (man_main, info) with
| `Error _ -> exit 1
| _ -> exit 0
