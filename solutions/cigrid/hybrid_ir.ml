open Printf
open Ast

type ir_stmt =
  | IRSExpr of expr
  | IRSVarAssign of string * expr
  | IRSVarDecl of string * ty

type ir_blockend = 
  | IRSReturn of expr option
  | IRSBranch of expr * string * string
  | IRSJump of string 

type ir_block = IRBlock of string * ir_stmt list * ir_blockend

type param = ty * string

type ir_global = IRFunc of ty * string * param list * ir_block list


(*copy from slides*)
(* let rec cfg_stmts l l_next acc_stmts blocks = function
  | SExpr(e)::xs -> cfg_stmts l l_next (IRSExpr(e)::acc_stmts) blocks xs
  | SVarDef(ty,s,e)::xs -> cfg_stmts l l_next
      (IRSVarAssign(s, e)::IRSVarDecl(s, ty)::acc_stmts) blocks xs
  | SVarAssign(s, e)::xs -> cfg_stmts l l_next (IRSVarAssign(s, e)::acc_stmts) blocks xs 
  | SScope(lst)::xs -> cfg_stmts l l_next acc_stmts blocks (lst@xs) 
  | SReturn(e_op)::_ -> IRBlock(l, (List.rev acc_stmts, IRSReturn(e_op)))::blocks
  | [] ->
    let blockend =
      (match l_next with
      | None -> IRSReturn(None)
      | Some l2 -> IRSJump(l2)) in
    IRBlock(l, (List.rev acc_stmts, blockend))::blocks *)


    (* | SIf(e,t_stmt,None)::xs ->
    let l_true = unique "if_true" in
    let l_after = unique "after_if" in
    let b_before = IRBlock(l, (List.rev acc_stmts, IRSBranch(e, l_true, l_after))) in
    let blocks2 = cfg_stmts l_true (Some(l_after)) [] (b_before::blocks) [t_stmt] in
    cfg_stmts l_after l_next [] blocks2 xs *)


(*generate Ir from ast*)

let rec cfg_IrBlockEnd stmts =
  match stmts with
  | (SReturn(e)::[]) -> IRSReturn(e) 
  | (_::t) ->  cfg_IrBlockEnd t

let rec cfg_IrStmts stmts acc_stmts = 
  match stmts with
  | h::[] -> List.rev acc_stmts
  | SVarDef(t, r, e)::xs -> cfg_IrStmts xs (IRSVarAssign(r, e)::IRSVarDecl(r, t)::acc_stmts)
  | SVarAssign(r, e)::xs -> cfg_IrStmts xs ((IRSVarAssign(r, e))::acc_stmts)
  | _ -> print_endline "could not match at cfg_IrStmts"; exit 1

let cfg_IrBlock scope name =
  match scope with
  | SScope(stmts) -> IRBlock(name, (cfg_IrStmts stmts []), (cfg_IrBlockEnd stmts))

let cfg_IrGlobal global = 
  match global with
  | GFuncDef(t, r, l, s) -> IRFunc(t, r, l, ([cfg_IrBlock s r]))

let rec cfg_generate ast ir =
  match ast with
  | Prog(g::t) -> cfg_IrGlobal g
  | _ -> failwith "TODO"


(*pretty print what we get from the above part*)

let pprint_IrStmt s =
  match s with
  | IRSVarDecl(r, t) -> "IRSVarDecl(" ^ "\""^ r ^"\"" ^ "," ^ (Ast.pprint_ty t) ^ ") \n"
  | IRSVarAssign(r, e) -> "IRSVarAssign(" ^ "\""^ r ^"\"" ^ "," ^ (Ast.pprint_expr e) ^ ") \n"  


let rec pprint_BlockStmts block =
  match block with
  | [] -> ""
  | (s::t) -> (pprint_IrStmt s) ^ (pprint_BlockStmts t)


let pprint_BlockEnd blockEnd =
  match blockEnd with
  | IRSReturn(None) -> "IRSReturn()"
  | IRSReturn(Some(e)) -> "IRSReturn(" ^ (Ast.pprint_expr e) ^ ")"
  | IRSBranch(e, r1, r2) -> "IRSBranch(" ^ (Ast.pprint_expr e) ^ r1 ^ r2 ^ ")"
  | IRSJump(r) -> "IRSJump(" ^ r ^ ")"

let pprint_Global g =
  match g with
  | IRFunc(t, r, p, [IRBlock(label, stmts, blockEnd)]) ->
      "IRFunc(" ^ (Ast.pprint_ty t) ^ ", " ^ r ^ ", {" ^ (paramsToString p "") ^ "}, { \n IRBlock({" ^ label ^ ", \n" ^ (pprint_BlockStmts stmts) ^ "\n" ^ (pprint_BlockEnd blockEnd) ^ "}) \n })"
and 
      paramsToString paramsList acc = 
        match paramsList with 
        | [] -> acc 
        | x::xs ->   paramsToString xs ( acc ^ "("^ pprint_param x ^")")
and 
      pprint_param each_param = 
        match each_param with
        | (t,s) -> Ast.pprint_ty t ^ "," ^ "\"" ^ s ^ "\""


