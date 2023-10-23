
open Printf

type bop = 
  | BopAdd 
  | BopSub 
  | BopMul 
  | BopDiv 
  | BopRem 
  | BopSma 
  | BopBig 
  | BopSme
  | BopBie
  | BopEqu
  | BopNeq
  | BopAnd
  | BopOr
  | BopAndd
  | BopOrr

type ty =
  | TVoid
  | TInt
  | TChar
  | TIdent of string

type uop = 
  | UnopMinus
  | UnopMark 
  | UnopTilde

type expr =
  | EBinOp of bop * expr * expr
  | EUnOp  of uop * expr
  | EVar   of string
  | EInt   of int
  | ECall  of string * expr list
  | EChar of char

type stmt =
  | SVarDef of ty * string * expr
  | SScope of stmt list
  | SIf of expr * stmt * stmt option
  | SWhile of expr * stmt
  | SBreak
  | SReturn of expr option
  | SExpr of expr
  | SVarAssign of string * expr



type lvalue =
  (* | EArrayAccess of ty * expr * ty option *)
  | ELvar of string

type global =
  | GFuncDef of ty * string * (ty * string) list * stmt
  | GVarDef of ty * string * expr
  | GFuncDecl of ty * string * (ty * string) list
  | GVarDecl of ty * string

type program =
  | Prog of global list


let pprint_uop = function
  | UnopMinus -> "-"
  | UnopMark -> "!"
  | UnopTilde -> "~"

let pprint_ty = function
  | TVoid -> "TVoid"
  | TInt -> "TInt"
  | TChar -> "TChar"

let pprint_bop = function
  | BopAdd -> "+"
  | BopSub -> "-"
  | BopMul -> "*"
  | BopDiv -> "/"
  | BopRem -> "%"
  | BopSma -> "<"
  | BopBig -> ">"
  | BopBie -> ">="
  | BopSme -> "<="
  | BopEqu -> "=="
  | BopNeq -> "!="
  | BopAnd -> "&"
  | BopOr -> "|"
  | BopAndd -> "&&"
  | BopOrr -> "||"


(* let rec stringListToString strList acc = 
  match strList with 
  | [] -> acc 
  | x::xs ->   stringListToString xs (pprint_expr x ^ acc)   *)

let rec pprint_expr = function
  | EBinOp(bop, e1, e2) ->
     "EBinOp(" ^ pprint_bop bop ^ ", " ^ pprint_expr e1 ^ "," ^ pprint_expr e2 ^ ")"
  | EUnOp(uop, e) ->
     "EUnOp(" ^ pprint_uop uop ^ ", " ^ pprint_expr e ^ ")"
  | EVar(r) -> 
     "EVar" ^ "(" ^"\""^ r^"\"" ^ ")"
  | EInt(i) ->
    "EInt" ^ "(" ^ (string_of_int i) ^ ")"
  | ECall(r,e1) ->
    "ECall"^ "(" ^"\""^ r ^"\"" ^"," ^"{" ^ (stringListToString e1 "") ^  "}" ^")"
  | EChar('"') ->
    sprintf "EChar('\\\"')"
  | EChar(c) ->
    sprintf "EChar(%C)" c
and 
  stringListToString strList acc = 
    match strList with 
    | [] -> acc 
    | x::xs ->   stringListToString xs (acc ^ pprint_expr x )


let pprint_varassign = function
    | SVarDef(t,r,e) ->
      "SVarDef" ^ "(" ^ (pprint_ty t) ^ "," ^"\""^ r^"\"" ^ "," ^ (pprint_expr e) ^ ")"

let rec pprint_stmt = function
    | SExpr(e) ->
      "SExpr" ^ "(" ^ pprint_expr e ^ ")"
    | SVarDef(t,r,e) ->
      "SVarDef" ^ "(" ^ (pprint_ty t) ^ "," ^"\""^ r^"\"" ^ "," ^ (pprint_expr e) ^ ")"
    (* | SScope(stmtlist) ->
      "SScope" ^ "(" ^ "{" ^ (stmtListToString stmtlist "") ^ "}" ^ ")" *)
    | SScope(stmtlist) ->
        "SScope" ^ "(" ^"{"^ (stmtListToString stmtlist "") ^ "}" ^ ")"
    | SWhile(e, s) ->
      "SWhile" ^ "(" ^ pprint_expr e ^ "," ^ pprint_stmt s ^ ")" 
    | SBreak ->
      "SBreak"
    | SIf(e, s, o) ->
      "SIf" ^ "(" ^ pprint_expr e ^ "," ^ pprint_stmt s ^ "," ^ pprint_stmt_option o ^ ")"
    | SReturn(e)  ->
      "SReturn" ^ "(" ^pprint_expr_option e ^ ")"
    | SVarAssign(r,e) ->
      "SVarAssign" ^ "(" ^"\""^ r^"\"" ^","^ pprint_expr e ^ ")" 
and 
      pprint_stmt_option stmt_option =
        match stmt_option with
        | None -> ""
        | Some(stmt_option) -> pprint_stmt stmt_option
and 
      pprint_expr_option expr_option =
        match expr_option with
        | None -> ""
        | Some(expr_option) -> pprint_expr expr_option
and 
      stmtListToString stmtList acc = 
        match stmtList with 
        | [] -> acc 
        | x::xs ->   stmtListToString xs (acc ^ pprint_stmt x )


(* let rec pprint_lvalue = function *)
    (* | EArrayAccess(r, e, s) ->
      "EArrayAccess" ^ "(" ^ pprint_ty r ^ "," ^ pprint_expr e ^ "," ^ pprint_ty_option s ^ ")"
and 
      pprint_ty_option ty_option =
        match ty_option with
        | None -> ""
        | Some(ty_option) -> pprint_ty ty_option  *)

let rec pprint_global = function 
    | GVarDef(t, r, e) ->
      "GVarDef" ^ "(" ^ (pprint_ty t) ^ "," ^ r ^ "," ^ (pprint_expr e) ^ ")" 
    | GFuncDef(t, r,l, s) ->
      "GFuncDef" ^ "(" ^ (pprint_ty t) ^ "," ^"\""^ r^"\"" ^ "," ^ "{" ^ paramsToString l "" ^ "}" ^","^  pprint_stmt s ^ ")" 
    | GFuncDecl(t, r,l) ->
      "GFuncDecl" ^ "(" ^ pprint_ty t ^ "," ^"\""^ r^"\"" ^ "," ^ "{" ^ paramsToString l "" ^ "}" ^ ")"
    |  GVarDecl(t, r) ->
      "GVarDecl" ^ "(" ^ pprint_ty t ^ "," ^"\""^ r^"\"" ^ ")"
and 
      paramsToString paramsList acc = 
        match paramsList with 
        | [] -> acc 
        | x::xs ->   paramsToString xs ( acc ^ "("^ pprint_param x ^")")
and 
      pprint_param each_param = 
        match each_param with
        | (t,s) -> pprint_ty t ^ "," ^ "\"" ^ s ^ "\""



let rec pprint_program = function
    | Prog(globalList) -> (globalListToString globalList "")
and 
      globalListToString globalList acc = 
        match globalList with 
        | [] ->  acc 
        | x::xs ->   globalListToString xs (acc ^"\n"^ pprint_global x)
    
      
