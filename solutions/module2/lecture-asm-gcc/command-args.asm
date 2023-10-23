; Tests the command line. Similar to a C main function:
;  int main(int argc, char** argv)
;
; - argc, number of args in rdi
; - argv, pointer to pointer in rsi and argv
;
; Test the program
; make && ./command-args.asm.out foo bar
                                ;
        
        global  main
        extern  puts

        section .data
        
num:    db      0,0
        
        section .text
main:
        mov     rbp, rdi        ; argc in rdi. Save in rbp, caller-saved
        mov     rbx, rsi        ; argv in rsi. Save in rbx, caller-saved
        
        mov     rdi, num        ; print out the number of arguments
        mov     al, bpl
        add     al, '0'
        mov     [rdi], al
        call    puts

loop:                           ; print out all arguments
        mov     rdi, [rbx]
        call    puts
        add     rbx, 8
        dec     rbp
        jnz     loop
        
        ret


        




        
