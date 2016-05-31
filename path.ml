let rec read_dir ~path ~paths_list =
  let children = Sys.readdir path in
  Array.fold_left
    (
      fun p_list child ->
        let full_path = match path with
          "./" -> path ^ child
          | _ -> path ^ "/" ^ child
        in
        match (Sys.is_directory full_path) with
        | true -> (full_path ^ "/") :: (read_dir ~path:full_path ~paths_list:p_list)
        | _ -> full_path :: p_list
    )
    paths_list
    children


let print_path_list ~include_re ~exclude_re ~paths_list =
  List.iter
    (
      fun line ->
        if Str.string_match (Str.regexp include_re) line 0 then begin
          if (Str.string_match (Str.regexp exclude_re) line 0) = false then
            print_endline (Str.replace_first (Str.regexp "\\/\\/") "/" line)
        end
    )
    paths_list
