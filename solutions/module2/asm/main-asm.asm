        global  main
        extern  puts
        extern  atoi
        extern  factorial_message
        extern  putchar



menu:      ; 10 is for '\n' , 0 for '\0'(null terminated string in C)
          db      "usage: <command> <arg1> <arg2>", 10, 10
          db      "commands:" , 10
          db      "  e   Echo arguments arg1 and arg2" , 10
          db      "  m   Prints out a magic number" , 10
          db      "  +   Adds together arg1 and arg2" , 10
          db      "  !   Prints out the factorial value of" , 10
          db      "      arg1, as well as the message in arg2", 10, 0
        


        section .text
main:
        mov     rbp, rdi        ; read and save the first command argument
        mov     rbx, rsi        ; read and save the second command argument

        cmp     rdi, 4          ; if less then 4 arguments then print out menu
        jl      output_menu

        mov     rdi, [rbx+8]    ; bracket means memory operands
        mov     r12b, [rdi]     ; store the first argument 

        cmp     r12b, 'e'       ; if argument is 'e', Echo arguments arg1 and arg2
        je      echo

        cmp     r12b, 'm'       ; if argument is 'm', Prints out a magic number
        je      output_magicnumber

        cmp     r12b, '+'       ; if argument is '+', Adds together arg1 and arg2
        je      sum

        cmp     r12b, '!'       ; Prints out the factorial value of arg1, as well as the message in arg2
        je      factorial

        jl      output_menu
        

output_menu:
        mov     rdi, menu       ; print the content of menu
        call    puts

        mov     rax, 1
        ret

echo:
        mov     rdi, [rbx+16]   ; store arg1
        call    puts

        mov     rdi, [rbx+24]   ; store arg2
        call    puts

        mov     rax, 0
        ret

sum:
        mov     rdi, [rbx+16]   ; parse second into integer
        call    atoi            ; atoi is the ‘ascii to integer’ function 
        mov     r13, rax        ; Integer return register: rax or rdx:rax

        mov     rdi, [rbx+24]   ; parse third arg into integer
        call    atoi
        mov     r14, rax

        add     r13, r14        ; result = r13 + r14

        mov     rdi, r13
        call    output_int

        mov     rax, 0
        ret

factorial:
        mov     rdi, [rbx+16]   ; parse second arg into integer
        call    atoi
        mov     rdi, rax

        mov     rsi, [rbx+24]   ; store the third arg and use it in the message information
        
        call    factorial_message; call the external function factorial_message

        mov     rdi, rax

        call    output_int

        mov     rax, 0
        ret

output_magicnumber:
        mov     rdi, -126       ; mov destination, source
        call    output_int

        mov     rax, 0
        ret

output_int:     ; based on main-c.c file
        mov     rbp, rdi 
        cmp     rbp, 0          ; if (x < 0), run this block
        jge     negative_case
        
        push    rdi             ; Push on stack  (Callee saved register)
        mov     rdi, '-'        ; give minus symbol to the negative number (overwrite rdi with "-")
        call    putchar         ; writes a character (an unsigned char) call putchar with '-' as argument
        pop     rdi             ; Pop from stack (overwrite rdi with original number)

        mov     rax, -1
        imul    rdi             ; Signed multiplication rdx:rax := rax * op1RM
        mov     rdi, rax

        jmp     negative_case
        
negative_case:
        mov     r12, 1000000    ; int i = 1000000
        mov     r13, 0          ; int b = 0

output_int_while_loop:
        cmp     r12, 0          ; while(i != 0)
        je      after_while_loop        
        cmp     rdi, r12                ; if  x >= i  
        jge     output_int_if           ; if x is greater or equal to i, jump to output_int_if

        cmp     r13, 0                  ; if b > 0
        jg      output_int_if           ; if b is greater than 0, jump to output_int_if

        cmp     rdi, 0                  ; if x == 0
        jne     after_if                ; if x equal to 0, jump to after_if

        cmp     r12, 1                  ; if i == 1
        jne     after_if                ; if i equal to 1, jump to after_if


output_int_if:
        mov     rdx, 0          ; divide x / i 
        mov     rax, rdi
        div     r12             ; divide x by i  Unsigned division
        mov     r14, rax        ; save the result in r14

        push    rdi             ; ;add '0' to argument
        add     r14, '0'        
        mov     rdi, r14
        call    putchar         ; call putchar with '0' + x/i as argument
        pop     rdi

        mov     r13, 1          ; Assign 1 to b


after_if:
        mov     rdx, 0          ; rax (rdx) := rdx:rax / op1RM
        mov     rax, rdi        ; mod x / i
        div     r12             ; 
        mov     rdi, rdx        ; move remainder to rdi register

        mov     rdx, 0          ; divide r12 by 10 every loop
        mov     rax, r12
        mov     rcx, 10
        div     rcx             ; divide i by 10  
        mov     r12, rax        ; move result to r12 register

        jmp     output_int_while_loop

after_while_loop:
        mov     rdi, 10         ; set 10 ('\n') as argument
        call    putchar         ; call putchar with '\n' as argument
       
        mov     rax, 0          ; return 0 as value when ret called
        ret                     ;