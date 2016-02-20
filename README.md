# inPathOCaml
A CLI tool for searching the paths beneath a given directory, written in OCaml

```sh
# build
mkdir _build
cd _build
ocamlfind ocamlopt -linkpkg -thread -package core ../inPath.ml -o inPath.native
# or just
corebuild inPath.native
```
