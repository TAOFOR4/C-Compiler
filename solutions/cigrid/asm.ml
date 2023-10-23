open Printf
open Ast
open Hybrid_ir

type unop = Inc | Dec | Push | Pop | IMul | IDiv | Not | Neg | Setg | Setl | Setge | Setle | Sete | Setne

type binop = Add | Sub | Cmp | Mov | And | Or | Xor

type displacement = int

type scale = int

type reg = int 

type op =
  | Imm of int 
  | Reg of reg
  | TReg of reg * string 
  | Mem of  reg * reg option * scale * displacement
  | NoOp

type inst =
  | UnOp of unop * op
  | BinOp of binop * op * op
  | Call of string
  | Cqo

type jbinop = Jl | Jg | Jle | Jge | Je | Jne

type blockend =
  | Ret
  | Jmp of string
  | JBinOp of jbinop * string * string

type block = Block of string * inst list * blockend

type func = Func of string * block list

(* type bitsize =
  | Byte | Word | DWord | QWord *)


let global_n = ref 0;;

(*make ir into asm style*)
let tmp_reg n = TReg(n, "tmp")

let make_reg l env =
  let (n, ty) = List.assoc l env in
  TReg(n, l)

let rec inst_select_expr env n acc reg expr =
  match expr with
  | EVar(x) -> (BinOp(Mov, reg, (make_reg x env))::acc, n)
  | EInt(v) -> (BinOp(Mov, reg, Imm(v))::acc, n)
  | EBinOp(BopAdd , EVar(x), EInt(v)) | EBinOp(BopAdd , EInt(v), EVar(x))
      when reg = make_reg x env -> (BinOp(Add, reg, Imm(v))::acc, n)
  | EBinOp(BopAdd , EVar(x), EVar(y))   
      when reg = make_reg x env -> (BinOp(Add, reg, make_reg y env)::acc, n)
  | EBinOp(BopAdd , EVar(y), EVar(x))   
      when reg = make_reg x env -> (BinOp(Add, reg, make_reg y env)::acc, n)
  | EBinOp(BopSub, EVar(x), EInt(v)) | EBinOp(BopSub, EInt(v), EVar(x))
      when reg = make_reg x env -> (BinOp(Sub, reg, Imm(v))::acc, n)
  | EBinOp(BopSub, EVar(x), EVar(y))   
      when reg = make_reg x env -> (BinOp(Sub, reg, make_reg y env)::acc, n)
  | EBinOp(BopSub, EVar(y), EVar(x))   
      when reg = make_reg x env -> (BinOp(Sub, reg, make_reg y env)::acc, n)
  | EBinOp(BopAdd , e1, e2) ->
      let (r1, r2) = (tmp_reg n, tmp_reg (n+1)) in
      let n1 = n + 2 in
      let acc1 = BinOp(Mov, reg, r1)::BinOp(Add, reg, r2)::acc in
      let (acc2, n2) = inst_select_expr env n1 acc1 r2 e2 in
      inst_select_expr env n2 acc2 r1 e1
  | EBinOp(BopSub, e1, e2) ->
      let (r1, r2) = (tmp_reg n, tmp_reg (n+1)) in
      let n1 = n + 2 in
      let acc1 = BinOp(Mov, reg, r1)::BinOp(Sub, reg, r2)::acc in
      let (acc2, n2) = inst_select_expr env n1 acc1 r2 e2 in
      inst_select_expr env n2 acc2 r1 e1
  | _ ->  failwith "TODO"; exit 1


let rec inst_select_ir_stmts env n acc stmts = 
  match stmts with
  | IRSVarAssign(x, expr)::xs ->
    let (expr_acc, n2) = inst_select_expr env n [] (make_reg x env) expr in
    inst_select_ir_stmts env n2 (List.rev_append expr_acc acc) xs
  | IRSVarDecl(x, ty)::xs ->
    inst_select_ir_stmts ((x, (n,ty))::env) (n+1) acc xs
  | [] -> (env, n, List.rev acc)
  | _ ->  failwith "TODO"; exit 1

let inst_select_ir_block_end env n acc blockEnd =
  match blockEnd with
  | IRSReturn(Some(expr)) -> 
    let (expr_acc, n2) = inst_select_expr env n [] (Reg(0)) expr in
    (Some(expr_acc), Ret)
  | IRSReturn(None) -> (None, Ret)
  | _ ->  failwith "TODO"; exit 1

let hybrid_ir_to_asm hybrid_ir =
  match hybrid_ir with
  | IRFunc(ty,str,param_list,ir_block_list) ->
    match ir_block_list with
    | block :: _ ->
        match block with
        | IRBlock(s, stmts, blockEnd) -> (
          let (env, n, acc) = inst_select_ir_stmts [] 0 [] stmts in 
          global_n := n ;  (*to get the number of registers*)
          match inst_select_ir_block_end env n [] blockEnd with
          | (None, ret) -> Block(s, acc, ret)
          | (Some(stmt), ret) ->  Block(s, List.append acc stmt, ret)
        )
        | _ ->  failwith "TODO"; exit 1

(*pretty print the asm from above part*)
let pprintReg n =
  match n with
  | 0 -> "rax"
  | 3 -> "rbx"
  | 1 -> "rcx"
  | 2 -> "rdx"
  | 6 -> "rsi"
  | 7 -> "rdi"
  | 5 -> "rbp"
  | 4 -> "rsp"
  | 8 -> "r8"
  | 9 -> "r9"
  | 10 -> "r10"
  | 11 -> "r11"
  | 12 -> "r12"
  | 13 -> "r13"
  | 14 -> "r14"
  | 15 -> "r15"
  | _ -> print_endline("No such register " ^ (string_of_int n) ^ " exists"); exit 1


let pprintUop uop =
  match uop with
  | Inc -> "inc"
  | Dec -> "dec"
  | Push -> "push"
  | Pop -> "pop"
  | IMul -> "imul"
  | IDiv -> "idiv"
  | Not -> "not"
  | Neg -> "neg"
  | Setg -> "setg"
  | Setl -> "setl"
  | Setge -> "setge"
  | Setle -> "setle"
  | Sete -> "sete"
  | Setne -> "setne"
(*The first two come from PDF*)


let pprintOp op = 
  match op with
  | Imm(n) -> string_of_int n
  | Reg(r) -> pprintReg r
  | TReg(r, name) -> 
    (* name ^ "_" ^ (string_of_int r) *)
    (match r with
    | 0 ->
        "qword [rsp]"
    | num ->
        "qword [rsp+" ^ string_of_int((num)*8) ^ "]")
  | Mem(r1, Some(r2), sc, disp) ->
    "[" ^ (pprintReg r1) ^ "+" ^ (string_of_int r2) ^ "*" ^ (string_of_int sc) ^ "+" ^ (string_of_int disp) ^ "]"
  | Mem(r1, None, sc, disp) -> 
    "qword [" ^ (pprintReg r1) ^ "*" ^ (string_of_int sc) ^ "+" ^ (string_of_int disp) ^ "]"
  | NoOp -> "nop"

let pprintBop bop =
  match bop with
  | Add -> "add\t"
  | Sub -> "sub\t"
  | Cmp -> "cmp\t"
  | Mov -> "mov\t"
  | And -> "and\t"
  | Or -> "or\t"
  | Xor -> "xor\t"

let rec pprintInstr instr =
  match instr with
  | BinOp(bop, op1, op2)::xs -> 
    (* "\t" ^ (pprintBop bop) ^ "\t" ^ (pprintOp op1) ^ ", " ^ (pprintOp op2) ^ "\n" ^ pprintInstr xs *)
    (match op2 with
            | Imm(integer) ->             
                "\t" ^ pprintBop bop ^ "\t" ^ pprintOp op1 ^ ", " ^ pprintOp op2 ^ "\n" ^ (pprintInstr xs) 
            | TReg(n ,str) ->
                "\t" ^ "mov" ^ "\t" ^ "r10" ^ ", " ^ pprintOp op2 ^ "\n" ^    
                (* "\t" ^ "mov" ^ "\t" ^ "rax" ^ ", " ^ pprintOp op2 ^ "\n" ^  *)

                "\t" ^ pprintBop bop ^ "\t" ^ pprintOp op1 ^ ", " ^ "r10" ^ "\n" ^ (pprintInstr xs)) 
  | UnOp(uop, op)::xs -> 
    "\t" ^ (pprintUop uop) ^ "\t" ^ (pprintOp op) ^ "\n" ^ pprintInstr xs 
  | [] -> ""

let pprintEndInstr endInstr = 
  match endInstr with
  | Ret -> "\tret"

let pprintBlock block =
  match block with
  | Block(s, instr, endInstr) -> 
    print_endline (s ^ ":\n"); 
    print_endline ("\tsub\trsp,\t" ^ string_of_int(!global_n * 3 * 8) ^ "\n");
    print_endline (pprintInstr instr);  
    print_endline ("\tadd\trsp,\t" ^ string_of_int(!global_n * 3 * 8) ^ "\n");
    print_endline (pprintEndInstr endInstr);
    exit 0

    
let pprint block =
  print_endline "\tglobal\tmain";
  print_endline "\tsection\t.text";
  pprintBlock block


