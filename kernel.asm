bits 16
org 0x1000

start:
    mov si, message
    call print_string

Eden:
    mov si, prompt
    call print_string

keyboard_loop:
    mov ah, 0x00
    int 0x16

    cmp al, 13
    je enter_pressed

    cmp al, 8
    je backspace

    mov si, input_buffer
    xor bx, bx
    mov bl, [input_index]
    add si, bx
    mov [si], al

    inc byte [input_index]

    mov ah, 0x0E
    int 0x10

    jmp keyboard_loop

enter_pressed:

    mov ah,0x0E
    mov al,13
    int 0x10

    mov al, 10
    int 0x10

    cmp byte [input_index], 5
    je help

    cmp byte [input_index], 6
    je clear

    mov si, prompt
    call print_string
    
    mov byte [input_index], 0
    
    jmp keyboard_loop

backspace:

    cmp byte [input_index], 0
    je keyboard_loop
    
    dec byte [input_index]

    mov si, input_buffer
    xor bx, bx
    mov bl, [input_index]
    add si, bx
    mov byte [si], 0

    mov ah, 0x0E

    mov al, 8
    int 0x10

    mov al, ' '
    int 0x10

    mov al, 8
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

help:

    cmp byte [input_buffer], '/'
    jne reset_command

    cmp byte [input_buffer + 1], 'h'
    jne reset_command

    cmp byte [input_buffer + 2], 'e'
    jne reset_command

    cmp byte [input_buffer + 3], 'l'
    jne reset_command

    cmp byte [input_buffer + 4], 'p'
    jne reset_command
    

    mov si, help_message
    call print_string

    mov si, prompt
    call print_string

    mov byte [input_index], 0

    jmp keyboard_loop

clear:

    cmp byte [input_buffer], '/'
    jne reset_command

    cmp byte [input_buffer + 1], 'c'
    jne reset_command

    cmp byte [input_buffer + 2], 'l'
    jne reset_command

    cmp byte [input_buffer + 3], 'e'
    jne reset_command

    cmp byte [input_buffer + 4], 'a'
    jne reset_command

    cmp byte [input_buffer + 5], 'r'
    jne reset_command

    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    mov ah, 0x02
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 0x10

    mov byte [input_index], 0

    jmp Eden

reset_command:

    mov byte [input_index], 0

    mov si,prompt
    call print_string

    jmp keyboard_loop


message db ' ',13,10
        db 'Welcome to Eden!', 13,10
        db 'My name is Kuntal',13,10
        db ' ',13,10,0

prompt  db 'Eden> ', 0

input_buffer times 50 db 0
input_index db 0

help_command db 'help',13,10,0
help_message db '|--Available Commands--|',13,10
             db '/help',13,10,
             db '/clear (Clears the terminal)',13,10,0
