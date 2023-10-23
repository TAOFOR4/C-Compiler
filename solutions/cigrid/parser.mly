
%{
   open Ast
%}


%token EQUAL "="
%token ADD "+"
%token SUB "-"
%token MUL "*"
%token DIV "/"
%token REM "%"
%token SMA "<"
%token BIG ">"
%token SME "<="
%token BIE ">="
%token EQUALL "=="
%token NONEQUAL "!="
%token AND "&"
%token OR "|"
%token ANDD "&&"
%token ORR "||"
%token COM ","
%token SEM ";"



%token TVOID "void"
%token TINT "int"
%token TCHAR "char"
%token SIF "if"
%token SELSE "else"
%token SWHILE "while"
%token SBREAK "break"
%token SRETURN "return"
%token SEXTERN "extern"


%token LPAREN "("
%token RPAREN ")"
%token LBRACKET "{"
%token RBRACKET "}"
%token LBRACE "["
%token RBRACE "]"
%token SQUOTE "\'"


%token <int> INT
%token <string> IDENT
%token <char> CHAR
%token EOF

%token MARK "!"
%token TILDE "~"


%left "||"
%left "&&"
%left "|"
%left "&"
%left "==" "!="
%left "<" ">" "<=" ">="
%left "+" "-"
%left "*" "/" "%"
%nonassoc UMINUS

%start main
%type <program> main

%%

main:
  | p = program EOF
    { p }

program:
  | globalList = list(global)
    { Prog(globalList) }

global:
  | t = ty r = IDENT "=" e = expr ";"
    { GVarDef(t, r, e) }
  | t = ty r = IDENT "(" p = params ")" "{" stmtlist = list(stmt)  "}"
    { GFuncDef(t, r, p , SScope(stmtlist)) }
  | "extern" t = ty r = IDENT "(" p = params ")" ";" 
    { GFuncDecl(t, r, p) }
  | "extern" t = ty r = IDENT ";"
    { GVarDecl(t, r) }

params:
  | exprlist = separated_list(",",  pair(ty ,IDENT))
    { exprlist }


varassign:
  | t = ty r = IDENT "=" e = expr
    { SVarDef(t, r, e) }
  | a = assign
    { a }

assign:
  | r = IDENT "("  exprlist = separated_list(",", expr)  ")"
    { SExpr(ECall(r,exprlist ))  }
  |  l = lvalue "=" e = expr
    { 
      match l with
      | EVar(x) -> SVarAssign(x, e) 
    }
  | l = lvalue "+" "+"
    { 
      match l with
      | EVar(x) -> SVarAssign(x,EBinOp(BopAdd,EVar(x),EInt(1))) 
    }
  | l = lvalue "-" "-"
    { 
      match l with
      | EVar(x) -> SVarAssign(x,EBinOp(BopSub,EVar(x),EInt(1))) 
    }

lvalue:
  | x = IDENT
    { EVar(x) }
  // | r = IDENT "[" e = expr "]" 
  //   { EArrayAccess(r, e, None) }
  // | r = IDENT "[" e = expr "]" l = IDENT
  //   { EArrayAccess(r, e, Some(l)) }

stmt:
  | var = varassign ";"
    { var }
  |  "{" stmtlist = list(stmt)  "}"
    { SScope(stmtlist) }
  |  "if" "(" e = expr ")" s = stmt  
    { SIf(e, s, None) }
  | "if" "(" e = expr ")" s = stmt  "else" o =stmt
    { SIf(e, s, Some(o)) }
  |  "while" "(" e = expr ")" s = stmt
    { SWhile(e, s) }
  | "break" ";"
    { SBreak }
  | "return"  ";" 
    { SReturn(None)  }
  | "return" e = expr ";" 
    { SReturn(Some(e))  }


expr:
  | x = INT
    { EInt(x) }
  | x = IDENT
    { EVar(x) }
  | e1 = expr bop = binop e2 = expr
    { EBinOp(bop,e1,e2) }
  | uop = unop e1 = expr
    { EUnOp(uop,e1) }
  | r = IDENT "("  exprlist = separated_list(",", expr)  ")"
    { ECall(r,exprlist )  }
  | "(" e1 = expr ")"
    { e1 }
  |  c = CHAR
    { EChar(c) }


%inline ty:
  | "void" 
    { TVoid }
  | "int"
    { TInt } 
  | "char" 
    { TChar }
  | r = IDENT
    { TIdent(r) }


%inline binop:
  | "+"
    {BopAdd}
  | "-"
    {BopSub}
  | "*"
    {BopMul}
  | "/"
    {BopDiv}
  | "%"
    {BopRem}
  | "<"
    {BopSma}
  | ">"
    {BopBig}
  | "<="
    {BopSme}
  | ">="
    {BopBie}
  | "=="
    {BopEqu}
  | "!="
    {BopNeq}
  | "&"
    {BopAnd}
  | "|"
    {BopOr}
  | "&&"
    {BopAndd}
  | "||"
    {BopOrr}




%inline unop:
  | "!" 
    {UnopMark}
  | "~" 
    {UnopTilde}
  | "-" 
    {UnopMinus}

