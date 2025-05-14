section .data
    inputBuf db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputLen equ $ - inputBuf

    space db ' '
    newline db 0x0A ; ASCII for newline

section .bss
    outputBuf resb 80 ; Sufficient space for 8 bytes * 3 characters/byte ("XX ") + newline

section .text
    global _start

_start:
    mov esi, inputBuf       ; ESI points to the start of inputBuf
    mov edi, outputBuf      ; EDI points to the start of outputBuf
    mov ecx, inputLen       ; ECX holds the number of bytes to process (loop counter)

convertToHex:
    ; Process a byte from inputBuf
    mov al, [esi]           ; Load byte from inputBuf into AL

    ; Get the upper nibble
    mov ah, al              ; Copy AL to AH
    shr ah, 4               ; Shift upper nibble to lower 4 bits

    ; Convert upper nibble to ASCII hex character
    cmp ah, 9               ; Compare with 9
    jbe is_digit_upper      ; If less than or equal to 9, it's a digit
    add ah, 'A' - 10        ; If greater than 9, add offset for 'A'-'F'
    jmp store_upper

is_digit_upper:
    add ah, '0'             ; If digit, add offset for '0'

store_upper:
    mov [edi], ah           ; Store the upper hex character in outputBuf
    inc edi                 ; Move outputBuf pointer

    ; Get the lower nibble
    mov ah, al              ; Copy original AL to AH
    and ah, 0x0F            ; Mask out the upper nibble

    ; Convert lower nibble to ASCII hex character
    cmp ah, 9               ; Compare with 9
    jbe is_digit_lower      ; If less than or equal to 9, it's a digit
    add ah, 'A' - 10        ; If greater than 9, add offset for 'A'-'F'
    jmp store_lower

is_digit_lower:
    add ah, '0'             ; If digit, add offset for '0'

store_lower:
    mov [edi], ah           ; Store the lower hex character in outputBuf
    inc edi                 ; Move outputBuf pointer

    ; Add a space separator
    mov al, [space]
    mov [edi], al
    inc edi

    inc esi                 ; Move inputBuf pointer
    loop convertToHex       ; Decrement ECX and loop if not zero

    ; Add a newline character at the end
    mov al, [newline]
    mov [edi], al
    inc edi

    ; Calculate the length of the output string
    mov edx, edi            ; Copy current outputBuf pointer to EDX
    sub edx, outputBuf      ; Subtract the start address to get the length

    ; Print the outputBuf to the screen
    mov eax, 4              ; sys_write system call number
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov ecx, outputBuf      ; Pointer to the string to write
    int 0x80                ; Call the kernel

    ; Exit the program
    mov eax, 1              ; sys_exit system call number
    xor ebx, ebx            ; Exit code 0
    int 0x80                ; Call the kernel

