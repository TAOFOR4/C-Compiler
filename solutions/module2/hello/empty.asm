    global main
    extern puts
msg:
    db "Hello world!",0
main:
    mov rdi, msg
    call puts
    mov rax,32
    ret