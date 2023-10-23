
{
  open Parser
  exception Error of char
}


let letter = ['A'-'Z'] | ['a'-'z']
let digit = ['0'-'9']
let digits = '0' | (['1'-'9']['0'-'9']*)
let non_digit = '_' | letter
let ident = non_digit (digit | non_digit)*
let charc = letter | digit
let spec_char = "'" "\\" ['n' 't' '\'' '\"' '\\'] "'"
let spec_char_dot = "'" "." "'"
let spec_char_sminus = "'" "-" "'"

let bigequal = ">="
let smallequal = "<="
let equal = "=="
let nonequal = "!="
let andand = "&&"
let oror = "||"
let multline_comment = "/*"
let multline_comment2 = "*/"

let line_comment = "//" [^ '\n']*

let Lib = "#" [^ '\n']*

rule token = parse
   | ['!']
        { MARK }
   | ['~']
        { TILDE }
   |  [' ' '\t'] | line_comment | Lib
       { token lexbuf }
   | ['\n']
       { Lexing.new_line lexbuf; token lexbuf }
   | ident as str
       { match str with
         | "void" -> TVOID
         | "int" -> TINT
         | "char" -> TCHAR
         | "if" -> SIF
         | "else" -> SELSE
         | "while" -> SWHILE
         | "break" -> SBREAK
         | "return" -> SRETURN
         | "extern" -> SEXTERN
         | s -> IDENT(s)
       }
   | ['=']
       { EQUAL }
   | ['+']
       { ADD }
   | ['-']
       { SUB }
   | ['*']
       { MUL }
   | ['/']
       { DIV }
   | ['%']
        { REM }
   | ['<']
        { SMA }
   | ['>']
        { BIG }
   | bigequal
        { BIE }
   | smallequal
        { SME }
   | equal
        { EQUALL }
   | nonequal
        { NONEQUAL }
   | '&'
        { AND } 
   | '|' 
        { OR }
   | ','
        { COM }
   | ';'
        { SEM }
   | andand
        {ANDD}
   | oror
        {ORR}
   | '('
        {LPAREN}
   | ')'
        {RPAREN}
   | '{'
        {LBRACKET}
   | '}'
        {RBRACKET}
   | '['
        {LBRACE}
   | ']'
        {RBRACE}
   | '\''
        {SQUOTE}
   | digits as ints
        { INT(int_of_string ints) }
   | "\'" charc "\'" as chars
        {CHAR(chars.[1])}
   | spec_char_dot
        {CHAR('.')}
   | spec_char_sminus
        {CHAR('-')}
   | spec_char as spec
        {
          match spec.[2] with
          | 'n' -> CHAR('\n')
          | 't' -> CHAR('\t')
          | '\'' -> CHAR('\'')
          | '\\' -> CHAR('\\')
          | '\"' -> CHAR('\"')
        }
   | multline_comment
        {
          multline_comment lexbuf
        }
   | eof
       { EOF }
   | _ as c
       { raise (Error c) }
and multline_comment = parse
   | "*/" {token lexbuf}
   | "\n" {Lexing.new_line lexbuf; multline_comment lexbuf }
   | eof { raise (Error(' ')) }
   | _ { multline_comment lexbuf }