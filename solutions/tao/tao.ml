open Printf

let usage_msg = "append [-verbose] <file1> [<file2>] ... -o <output>"
let verbose = ref false
let pretty = ref false
let input_files = ref []
let output_file = ref ""

let anon_fun filename =
  input_files := filename::!input_files

let speclist =
  [("-verbose", Arg.Set verbose, "Output debug information");
   ("-o", Arg.Set_string output_file, "Set output file name");
   ("--pretty-print", Arg.Set pretty, "pretty print the result")]

let () =
  Arg.parse speclist anon_fun usage_msg;;
  (* Main functionality here *)

let main =
  printf "hello"