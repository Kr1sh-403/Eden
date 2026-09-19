bits 16
org 0x1000

start:
    mov si, message
    call print_string

keyboard_loop:
    mov ah, 0x00
    int 0x16

    mov ah, 0x0E
    int 0x10

    jmp keyboard_loop


print_string:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10

    jmp print_string

.done:
    ret


message db 'Welcome to Eden!', 13, 10
        db 'Eden> ', 0
