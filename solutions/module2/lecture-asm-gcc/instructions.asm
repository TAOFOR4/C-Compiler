; This file shows some properties of different x86 instructions.
; It is easy to extend this file to test more instructions.


        global  main            ; make the start symbol external
        extern  printf          ; states that puts exists in another object file

        section .data
        
db1:    db      0       ; declares 8 bits
db2:    db      0       
dw1:    dw      0       ; declares 16 bits
dw2:    dw      0
dd1:    dd      0       ; declares 32 bits
dd2:    dd      0
dq1:    dq      0       ; declares 64 bits
dq2:    dq      0      
        
        
        section .text
       
; Function info printer: esi = test string, edx = test value        
i_str:  db      "Test '%s'  output = %d", 10, 0        
info:
        mov     rdi, i_str
        xor     rax, rax
        call    printf
        ret        

        
main:
        
; Test itermediate and register to register addition. Expected output = 37
test_add_mov1:  
        mov     ecx, 10   
        mov     ebx, 20
        mov     edx, ecx
        add     edx, ebx  
        add     edx, 7            
        mov     rsi, str_add_mov1
        call    info
        jmp     test_add_mov2
str_add_mov1:    db      "str_add_mov1", 0


; Test memory access of mov and add. Expected output = 53
test_add_mov2:  
        mov     eax, 20          
        mov     rbx, dd1
        mov     dword [rbx], 30  ; need to say that it is a dword (32-bit)
        add     [rbx], eax
        add     dword [rbx], 3
        mov     edx, [rbx]        
        
        mov     rsi, str_add_mov2
        call    info
        jmp     test_decl_size_dw
str_add_mov2:    db      "str_add_mov2", 0

; Test declaration sizes of dw. Expected output = 2
test_decl_size_dw:
        mov     edx, dw2
        mov     ecx, dw1
        sub     edx, ecx
        mov     rsi, str_decl_size_dw
        call    info
        jmp     test_decl_size_dd
str_decl_size_dw:    db      "str_decl_size_dw", 0


; Test declaration sizes of dd. Expected output = 4
test_decl_size_dd:
        mov     edx, dd2
        mov     ecx, dd1
        sub     edx, ecx
        mov     rsi, str_decl_size_dd
        call    info
        jmp     test_decl_size_dq
str_decl_size_dd:    db      "str_decl_size_dd", 0


; Test declaration sizes of dq. Expected output = 8
test_decl_size_dq:
        mov     edx, dq2
        mov     ecx, dq1
        sub     edx, ecx
        mov     rsi, str_decl_size_dq
        call    info
        jmp     test_cmp_inst
str_decl_size_dq:    db      "str_decl_size_dq", 0


; Cmp instruction. Expected output = 55
; Note: cmp     [ebx], [ecx] is not allowed
test_cmp_inst:
        mov     edx, 5
        mov     ecx, 10
        cmp     edx, ecx
        jl      jump1           ; should jump
        mov     edx, 1000
jump1:
        mov     ebx, dd1
        mov     dword [ebx], 50
        mov     ecx, 100
        cmp     [ebx], ecx
        jg      jump2           ; should not jump
        add     edx, [ebx]
jump2:
        mov     rsi, str_cmp_inst
        call    info
        jmp     test_cond_move
str_cmp_inst:    db      "str_cmp_inst", 0
        

; Test declaration sizes of dq. Expected output = 8
test_cond_move:
        mov     eax, 7
        mov     ecx, 2
        mov     edx, 88
        mov     esi, 99
        cmp     eax, ecx
        cmovg  edx, esi
        mov     rsi, str_cond_move
        call    info
        jmp     test_ends
str_cond_move:    db      "str_cond_move", 0
        
test_ends:      
        ret
        
