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

convertToHexLoop:
    ; Load byte from inputBuf
    mov al, [esi]           ; Byte to translate is in AL

    ; Call subroutine to translate byte
    ; Input to subroutine: AL = byte value, EDI = destination buffer address
    call byteToHex

    ; Subroutine wrote 2 chars to [edi] and [edi+1]
    add edi, 2              ; Advance output pointer past the two hex chars

    ; Add a space separator in the main loop - CORRECTED
    mov bl, [space]         ; Load the byte value of space (0x20) into BL
    mov [edi], bl           ; Move the value from BL to the memory location [edi]
    inc edi

    inc esi                 ; Move inputBuf pointer
    loop convertToHexLoop   ; Decrement ECX and loop if not zero
    
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

; Subroutine to convert a byte in AL to 2 hex ASCII chars at [EDI] and [EDI+1]
; Clobbers AH. Preserves EDI and AL (by saving/restoring EAX)
byteToHex:
    push eax            ; Save AL (original byte) for processing lower nibble

    ; Process upper nibble
    mov ah, al          ; Copy byte to AH
    shr ah, 4           ; Shift upper nibble to lower 4 bits

    ; Convert upper nibble to ASCII hex character
    cmp ah, 9
    jbe .is_digit_upper
    add ah, 'A' - 10    ; Adjust for A-F
    jmp .store_upper
.is_digit_upper:
    add ah, '0'         ; Adjust for 0-9
.store_upper:
    mov [edi], ah       ; Store the upper hex character

    pop eax             ; Restore original byte to AL (and AH becomes whatever was saved)

    ; Process lower nibble
    mov ah, al          ; Copy original byte to AH
    and ah, 0x0F        ; Mask out the upper nibble

    ; Convert lower nibble to ASCII hex character
    cmp ah, 9
    jbe .is_digit_lower
    add ah, 'A' - 10    ; Adjust for A-F
    jmp .store_lower
.is_digit_lower:
    add ah, '0'         ; Adjust for 0-9
.store_lower:
    mov [edi+1], ah     ; Store the lower hex character

    ret                 ; Return from subroutine