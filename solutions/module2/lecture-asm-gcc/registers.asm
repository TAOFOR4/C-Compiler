
; Need to add this line to enable registers r0, r1 etc.        
%use altreg 
        
        global  main            
        extern  printf         

        section .data

str1:   db      "r%d = %d", 10
        
        section .text
main:
        
        mov     rax, 0          ; rax
        mov     rdx, r0
        mov     esi, 0
        mov     rdi, str1
        xor     rax, rax
        call    printf

        mov     rcx, 1          ; rcx
        mov     rdx, r1
        mov     esi, 1
        mov     rdi, str1
        xor     rax, rax
        call    printf

        mov     rdx, 2          ; rdx
        mov     rdx, r2
        mov     esi, 2
        mov     rdi, str1
        xor     rax, rax
        call    printf

        mov     rbx, 3          ; rbx
        mov     rdx, r3
        mov     esi, 3
        mov     rdi, str1
        xor     rax, rax
        call    printf

        mov     rax, rsp
        mov     rsp, 4          ; rsp
        mov     rdx, r4
        mov     rsp, rax
        mov     esi, 4
        mov     rdi, str1
        xor     rax, rax
        call    printf
        
        mov     rbp, 5          ; rbp
        mov     rdx, r5
        mov     esi, 5
        mov     rdi, str1
        xor     rax, rax
        call    printf

        mov     rsi, 6          ; rsi
        mov     rdx, r6
        mov     esi, 6
        mov     rdi, str1
        xor     rax, rax
        call    printf

        mov     rdi, 7          ; rsi
        mov     rdx, r7
        mov     esi, 7
        mov     rdi, str1
        xor     rax, rax
        call    printf
        
        ret
        
