
        .data
prompt: .asciiz 	     "Enter a string (less than 40 characters): "
buffer: .space 40            # Allocate 40 bytes for the string

        .text
        .globl main

main:
    # Print
    la   $a0, prompt         # Load address of our prompt
    li   $v0, 4              # Syscall for print_string
    syscall

    # Read the string
    la   $a0, buffer         # Buffer for storing the input
    li   $a1, 40             # Maximum number of characters to read
    li   $v0, 8              # Syscall for read_string
    syscall

    # Print string
    la   $a0, buffer         # Load address of the buffer
    li   $v0, 4              # Syscall for print_string
    syscall

    # Exit
    li   $v0, 10             # Syscall for exit
    syscall
