BITS 16
ORG 0x7C00

start:
    ; Set up segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Print "Hello"
    mov ah, 0x0E

    mov al, 'H'
    int 0x10

    mov al, 'e'
    int 0x10

    mov al, 'l'
    int 0x10

    mov al, 'l'
    int 0x10

    mov al, 'o'
    int 0x10

    mov al, ' '
    int 0x10
    ; -------------------------
    ; Load kernel from disk
    ; -------------------------

    mov ah, 0x02        ; BIOS read sectors function
    mov al, 1           ; Read 1 sector
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Sector 2
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; First hard disk

    mov bx, 0x1000      ; Load kernel at memory 0x1000

    int 0x13            ; BIOS disk interrupt

    ; Jump to the kernel
    jmp 0x0000:0x1000

hang:
    cli
    hlt
    jmp hang

times 510-($-$$) db 0
dw 0xAA55