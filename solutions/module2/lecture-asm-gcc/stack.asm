

        global  main            
        extern  printf         
        section .bss

hi:     resb    100
        
        section .data

_mem:   db      "mem %x, ", 10, 0
_rsp:   db      "rsp %x, ", 10, 0
        
        section .text

foo2:   
        mov     rdi, _rsp
        mov     rsi, rsp
        xor     rax, rax
        call    printf

        mov     rdi, _mem
        mov     rsi, [rsp]
        xor     rax, rax
        call    printf
        mov     qword [rsp],0
        
        ret
        
foo:
        mov     rdi, _rsp
        mov     rsi, rsp
        xor     rax, rax
        call    printf

        mov     rdi, _mem
        mov     rsi, [rsp]
        xor     rax, rax
        call    printf

        call    foo2
        ret

main:        
        mov     rdi, _rsp
        mov     rsi, rsp
        xor     rax, rax
        call    printf

        mov     rdi, _mem
        mov     rsi, [rsp]
        xor     rax, rax
        call    printf


        call    foo
        ret
        
