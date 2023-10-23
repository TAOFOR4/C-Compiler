; Simple example that show how printf can be called from         
; x86 assembly. Note that this asm program corresponds
; to the following function call in C:
; 
; printf("Hello printf: %d, %x", -782, 0x78912ab);


        global  main            
        extern  printf         

        section .data

str1:   db      "Hello printf: %d, %x", 10, 0        
        section .text
main:        
        mov     rdi, str1
        mov     esi, -782
        mov     rdx, 0x78912ab
        xor     rax, rax
        call    printf
        ret
        
