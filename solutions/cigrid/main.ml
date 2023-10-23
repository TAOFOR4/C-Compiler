(* An extended example with Menhir that outputs an abstract syntax tree (AST).
 * Copyright (C) David Broman, 2022. MIT License.
 *
 * This example shows how to parse and generate an abstract syntax tree.
 * The example also shows how keywords are handled, and how to
 * pretty print the AST.
 *
 * This video shows how the code is created:
 *   https://youtu.be/ly7yvyaDj08
 *)

 open Printf
 open Ast
 open Arg
 open Hybrid_ir
 open Asm
 
 let input_files = ref []
 
 let usage_msg = "append [--pretty-print] "
 
 let pretty = ref false
 
 let ir = ref false
 
 let asm = ref false
 
 let anon_fun filename =
   input_files := filename::!input_files
 
 let speclist =
   [("--pretty-print", Arg.Set pretty, "pretty print the result");
   ("--ir", Arg.Set ir, "print ir");
   ("--asm", Arg.Set asm, "print asm")]
 
 let () =
   try 
   Arg.parse_argv Sys.argv speclist anon_fun usage_msg
   with
   | Arg.Bad c -> exit 1;;
 
 let main =
   let lexbuf = input_files := (Array.get (Sys.argv) 2)::[]; Lexing.from_channel (open_in (List.hd !input_files)) in
   let res =
     try Parser.main Lexer.token lexbuf
     with
     | Lexer.Error c ->
        fprintf stderr "Lexical error at line %d: Unknown character '%c'\n"
          lexbuf.lex_curr_p.pos_lnum c;
        exit 1
     | Parser.Error ->
        fprintf stderr "Parse error at line %d:\n" lexbuf.lex_curr_p.pos_lnum;
        exit 1
   in
     let _ = res in
     let ir1 = [] in
     let ir2 = Hybrid_ir.cfg_generate res ir1 in
      (* Printf.printf "%s\n" (Asm.pprint (Asm.hybrid_ir_to_asm ir2) ) *)

    begin match !pretty with 
      | true -> Printf.printf "%s\n" (Ast.pprint_program res)
      | false -> ()
    end;
    begin match !ir with 
    | true -> Printf.printf "%s\n" (Hybrid_ir.pprint_Global ir2)
    | false -> ()
    end;
    begin match !asm with 
    | true -> Printf.printf "%s\n" (Asm.pprint (Asm.hybrid_ir_to_asm ir2))
    | false -> ()
    end
