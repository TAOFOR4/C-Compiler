
        global  main
        extern  puts
        extern  fflush

        section .text

hello_str       db      "Hello world!", 0
        

main:
        mov     rdi, hello_str
        call    puts
        mov	    rdi, 0
        call    fflush
        ret



        
