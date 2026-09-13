BITS 16
ORG 0x1000

start:
    mov si, message

print:
    lodsb
    cmp al, 0
    je halt

    mov ah, 0x0E
    int 0x10
    jmp print

halt:
    cli
    hlt
    jmp halt

message db "Eden Kernal Started!", 0