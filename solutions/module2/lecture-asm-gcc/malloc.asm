

        global  main         
        extern  printf
        extern  malloc
        extern  free
        
        section .text

msg:    db      "%4d, ",0    

; edi = pointer, esi = count
write_numbers:
        mov     [edi], esi
        add     edi, 8
        dec     esi
        jnz     write_numbers
        ret

print_numbers:
        mov     rax, [rdi]
        add     rdi, 8
        push    rdi
        push    rsi
        mov     rdi, msg
        mov     rsi, rax
        xor     rax, rax
        call    printf
        pop     rsi
        pop     rdi        
        dec     rsi
        jnz     print_numbers
        ret
        
main:
        mov     rdi, 8*100
        call    malloc
        mov     rbx, rax

        mov     rdi, rbx
        mov     rsi, 100
        call    write_numbers

                
        mov     rdi, rbx
        call    free
        
        mov     rdi, rbx
        mov     rsi, 100
        call    print_numbers
                             
        ret    
              
; What if
; - We move print_numbers after free?  
; - We do not malloc, and write anyway?  -> Segmentation fault (core dumped)
; - We write outside the allocated memory -> Sysmalloc assertion
; - We read outside the allocated memory -> Print garbage (what is inside the memory)
; - No crash, but malloc has changeed the first 16 bytes. Rest is still there. Not cleared.



        


