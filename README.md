# HW11
## Description

The program performs the following steps:

1.  Defines a hardcoded sequence of bytes in the `.data` section (`inputBuf`).
2.  Allocates a buffer in the `.bss` section (`outputBuf`) to store the translated ASCII string.
3.  Iterates through each byte in `inputBuf`.
4.  For each byte, it calls a subroutine (`byteToHex`) to perform the translation.
5.  The `byteToHex` subroutine takes a byte value and a destination address, converts the byte into two ASCII characters representing its hexadecimal value (e.g., `0x83` becomes the characters '8' and '3'), and stores these characters at the specified address.
6.  The main loop places the two translated hex characters into `outputBuf`, followed by a space character.
7.  After processing all bytes from `inputBuf`, the main loop adds a newline character to the end of `outputBuf`.
8.  Finally, it uses the Linux `sys_write` system call to print the contents of `outputBuf` to standard output (the console).
9.  The program then exits using the Linux `sys_exit` system call.

## Building

To build this program, you will need NASM (Netwide Assembler) and a linker (like `ld`).

1.  Save the assembly code as `HW11.asm`.
2.  Open a terminal and assemble the source file:
    ```bash
    nasm -f elf HW11.asm -o HW11.o
    ```
3.  Link the object file to create an executable:
    ```bash
    ld -m elf_i386 HW11.o -o hw11
    ```
Extra Credit 

1.  Save the assembly code as `HW11extra.asm`.
2.  Open a terminal and assemble the source file:
    ```bash
    nasm -f elf HW11extra.asm -o HW11extra.o
    ```
3.  Link the object file to create an executable:
    ```bash
    ld -m elf_i386 HW11extra.o -o hw11extra
    ```

## Running

Execute the compiled program from your terminal:

```bash
./hw11
