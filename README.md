# inPathOCaml
A CLI tool for searching the paths beneath a given directory, written in OCaml

```sh
# build
ocamlfind ocamlopt -linkpkg -thread -package core -package str inPath.ml -o inPath.native
```
