; Simple hello world program using the C 'puts' library function. 
;
; Note that when we use gcc to link, gcc will add som init code to _start and
; then call main function.
;

        global  main            ; make the start symbol external
        extern  puts            ; states that puts exists in another object file
        
        section .text

msg:    db      "Hello!",0      ; Declares a string, including hello world
                                ; In C, needs to end with a zero byte                
        
main:        
        mov     rdi, msg
        call    puts            ; Note that puts print to the standard output
                                ;   and also adds a newline
        mov     rax, 0          ; Returns form main. Returns to the cleanup
        ret                     ;   code generated by C. Return code in rax.
