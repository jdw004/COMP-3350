
.data
prompt:     .asciiz "Enter a string (must be <100 chars): "
resultMsg:  .asciiz "\nWord count: "
newLine:    .asciiz "\n"
inputBuf:   .space 100       # Reserve 100 bytes for input string

.text
.globl main

main:
    li   $v0, 4               # 4 = print_string
    la   $a0, prompt
    syscall

    # Read user input string
    li   $v0, 8               # 8 = read_string
    la   $a0, inputBuf        # Address of buffer
    li   $a1, 100             # Max number of bytes to read
    syscall

    # Initialize registers
    la   $t1, inputBuf        # $t1 = pointer to current char
    li   $s0, 0               # $s0 = wordCount
    li   $s1, 0               # $s1 = inWord flag 

count_loop:
    lb   $t0, 0($t1)          # Load the current character
    beq  $t0, $zero, done     # If char == 0 we reached the end of string


    # Check if character is alphabetic
    li   $t2, 'A'
    blt  $t0, $t2, not_alpha  # If $t0 < A, not alpha
    li   $t2, 'Z'
    ble  $t0, $t2, is_alpha   # If A <= char <= Z, it is alpha

    # Check lowercase
    li   $t2, 'a'
    blt  $t0, $t2, not_alpha  # If $t0 < a, not alpha
    li   $t2, 'z'
    bgt  $t0, $t2, not_alpha  # If $t0 > z, not alpha

is_alpha:
    # If we were not in a word before, we have started a new word
    beq  $s1, $zero, start_word
    j    continue_loop

not_alpha:
    # If it's not an alphabetic character, we end the word
    li   $s1, 0               # inWord = false
    j    continue_loop

start_word:
    addi $s0, $s0, 1          # Increment wordCount
    li   $s1, 1               # inWord = true

continue_loop:
    addi $t1, $t1, 1          # Move to next character
    j    count_loop

done:
    # Print result
    li   $v0, 4               # print_string
    la   $a0, resultMsg
    syscall

    li   $v0, 1               # print_int
    move $a0, $s0             # $s0 holds wordCount
    syscall

    li   $v0, 4               # print_string
    la   $a0, newLine
    syscall

    # Exit program
    li   $v0, 10
    syscall