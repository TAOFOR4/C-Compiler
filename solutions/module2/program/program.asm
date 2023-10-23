    global main
    extern printf
str:    
    db  "Number: %d",10, 0

main:
    mov rdi, str
    mov rsi, 65
    mov rax, rax
    call printf
    mov rax, 0
    ret