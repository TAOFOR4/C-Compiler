
{
open Token
}

rule token = parse
     [' ' '\t' '\n']
       { token lexbuf }
   | ['+']
       { ADD}
   | ['*']
       { MUL }
   | ['-']
       { SUB }
   | ['/']
       { DIV }
    | ['(']
       { LP}
    | [')']
       { RP }
   | ['0'-'9']+ as lxm
       { INT(int_of_string lxm) }
   | eof
       { EOF }