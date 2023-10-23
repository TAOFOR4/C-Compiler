; Simple example functions that shows how loops work, how you can write
; to a buffer in the .data section etc. These are some of the examples from
; lecture 4.
        
        global  main           
        extern  puts
        extern  putchar

        section .bss
str2:   resb    8
        
        section .data

hexstr: db      "0x00000000",10

        section .text
        
; edi = num, esi=buff address       
write_hex:
        mov     ecx, 8*4
        mov     edx, 8
hex_loop:
        sub     ecx, 4
        mov     eax, edi
        shr     eax, cl
        and     eax, 1111b
        cmp     eax, 10
        jl      hex_num
        add     eax, 'a' - 10
        jmp     hex_after
hex_num:
        add     eax, '0'
hex_after:
        mov     byte [esi], al
        inc     esi
        dec     edx
        jnz     hex_loop
        ret
        
        
; print x characters
; rdi = character pointer        
; rsi = number of characters
put_chars:
        mov     rcx, rdi
put_loop:   
        cmp     rsi, 0
        jz      exit_put_chars
        mov     dil, [rcx]

        push    rcx
        push    rsi
        call    putchar
        pop     rsi
        pop     rcx
        
        inc     rcx
        dec     rsi
        jmp     put_loop
exit_put_chars:      
        ret                       
        
main:
        mov     rdi, msg
        mov     esi, 6
        call    put_chars

        mov     rsi, hexstr
        add     rsi, 2
        mov     edi, 928213
        call    write_hex
        
        mov     rdi, hexstr
        mov     esi, 11
        call    put_chars


        add     edi, 0x21abc78f
        mov     rsi, str2
        call    write_hex
        
        mov     rdi, str2
        mov     esi, 8
        call    put_chars

        mov     rdi, 10
        call    putchar
        
        ret 

msg:    db      "Hello",10       ; note that we can put a read only string in .text










        
