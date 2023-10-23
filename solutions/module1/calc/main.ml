open Printf
open Token



type expr =
  | ExprAdd of (expr * expr)
  | ExprSub of (expr * expr)
  | ExprMul of (expr * expr)
  | ExprDiv of (expr * expr)
  | ExprNum of int

let get_token_list lexbuf  =
  let rec work acc =
    try
      match Lexer.token lexbuf with
      | EOF -> EOF::acc
      | t -> work (t::acc)
    with
    | _ -> exit 1
  in List.rev (work [])

let rec parseExpr tok token_list =
  let (tok2, expr, token_list2) = parseTerm tok token_list in
    parseExprPrime tok2 expr token_list2

and parseExprPrime tok expr token_list =
  if tok = ADD then
    let next = List.hd token_list in
      let (tok2, expr2, token_list2) = parseTerm next (List.tl token_list) in
        parseExprPrime tok2 (ExprAdd(expr,expr2)) token_list2
  else if tok = SUB then 
    let next = List.hd token_list in
      let (tok2, expr2, token_list2) = parseTerm next (List.tl token_list) in
        parseExprPrime tok2 (ExprSub(expr,expr2)) token_list2
  else (tok, expr, token_list)

and parseTerm tok token_list =
    let (tok2, expr, token_list2) = parseFactor tok token_list in
      parseTermPrime tok2 expr token_list2

and parseTermPrime tok expr token_list =
    if tok = MUL then 
      let next = List.hd token_list in
        let (tok2, expr2, token_list2) = parseFactor next (List.tl token_list) in
          parseTermPrime tok2 (ExprMul (expr, expr2)) token_list2
    else if tok = DIV then
      let next = List.hd token_list in
        let (tok2, expr2, token_list2) = parseFactor next (List.tl token_list) in
          parseTermPrime tok2 (ExprDiv (expr, expr2)) token_list2
    else (tok, expr, token_list)

and parseFactor tok token_list =
    match tok with
    | INT(n) -> let next = List.hd token_list in
            (next, ExprNum(n), List.tl token_list)
    | LP -> let next = List.hd token_list in
            let (tok2, expr2, token_list2) = parseExpr next (List.tl token_list) in
            if tok2 = RP then 
              let next2 = List.hd token_list2 in
                (next2, expr2, List.tl token_list2)
    else  exit 1
| _ -> exit 1

let parseMain token_list =
  let next = List.hd token_list in
    let (tok, expr, rest) = parseExpr next (List.tl token_list) in
      if tok <> EOF then exit 1
      else expr


let rec prettyprint parsetree =
  match parsetree with
  | ExprNum(n) -> printf "%d" n
  | ExprAdd(l,r) -> printf "(" ; prettyprint l ; printf "+" ;  prettyprint r ; printf ")"
  | ExprSub(l,r) -> printf "(" ; prettyprint l ; printf "-" ;  prettyprint r ; printf ")"
  | ExprMul(l,r) -> printf "(" ; prettyprint l ; printf "*" ;  prettyprint r ; printf ")"
  | ExprDiv(l,r) -> printf "(" ; prettyprint l ; printf "/" ;  prettyprint r ; printf ")"


let rec eval parsetree =
  match parsetree with
  | ExprNum(n) -> n
  | ExprAdd(l,r) -> (eval l) + (eval r)
  | ExprMul(l,r) -> (eval l) * (eval r)
  | ExprDiv(l,r) -> (eval l) / (eval r)
  | ExprSub(l,r) -> (eval l) - (eval r)



let main =
  let rec work n =
    try
      let strings = input_line stdin in
      if strings = "" then exit 0
      else
      let lexbuf = Lexing.from_string strings in
      let token_list = get_token_list lexbuf in
      let temp = get_token_list lexbuf in
      let resul =  parseMain token_list in
      prettyprint resul;
      printf "\n";
      let re = eval resul in
        printf "=%d\n" re ;
        flush stdout;
        work(n+1)
    with
    | End_of_file -> ()
  in
      work 1


