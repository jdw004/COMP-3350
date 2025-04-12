.data
promptF0:   .asciiz "Enter the first number (F0): "
promptF1:   .asciiz "Enter the second number (F1): "
promptN:    .asciiz "Enter the position (N): "
resultMsg:  .asciiz "The "
resultMsg2: .asciiz "-th Modified Fibonacci number is: "
newLine:    .asciiz "\n"
# We store F0 and F1 in memory so that the recursive procedure can retrieve them
F0: .word 0
F1: .word 0

.text
.globl main
main:
    # Prompt and read F0
    li   $v0, 4                # 4 = print_string
    la   $a0, promptF0
    syscall
    li   $v0, 5                # 5 = read_int
    syscall
    sw   $v0, F0               # Store user input in memory at F0

    # Prompt and read F1
    li   $v0, 4
    la   $a0, promptF1
    syscall
    li   $v0, 5
    syscall
    sw   $v0, F1               # Store user input in memory at F1

    # Prompt and read N
    li   $v0, 4
    la   $a0, promptN
    syscall
    li   $v0, 5
    syscall
    move $a0, $v0              # We'll pass N in $a0
    move $s0, $v0              # Save N in $s0 for later
    
    # Call modFib(N)
    jal  modFib                # Return value will be in $v0
    move $s1, $v0              # Save result in $s1 before it gets overwritten
    
    # Print the result message first part
    li   $v0, 4
    la   $a0, resultMsg
    syscall
    
    # Print N+1 (to show the correct position)
    li   $v0, 1
    addi $a0, $s0, 1           # N+1 
    syscall
    
    # Print the middle part of the message
    li   $v0, 4
    la   $a0, resultMsg2
    syscall
    
    # Print the Fibonacci result 
    li   $v0, 1                # print_int
    move $a0, $s1              # Move the saved result to $a0
    syscall

    # Exit program
    li   $v0, 10
    syscall

#   modFib
#   if (N == 0) return F0
#   if (N == 1) return F1
#   else return modFib(N-1) + modFib(N-2)
#   Input  $a0 = N
#   Output $v0 = the Nth Modified Fibonacci number
modFib:
    # Base Case 1 N == 0
    beq  $a0, $zero, returnF0
    # Base Case 2 N == 1
    li   $t0, 1
    beq  $a0, $t0, returnF1
    # Otherwise modFib(N-1) + modFib(N-2)
    # Save caller saved registers
    addi $sp, $sp, -12          # Make space on stack for 3 words
    sw   $ra, 8($sp)            # Save return address
    sw   $a0, 4($sp)            # Save N
    sw   $t1, 0($sp)            # Save $t1 as we'll use it

    # Compute modFib(N-1)
    addi $a0, $a0, -1          # N - 1
    jal  modFib                # Returns in $v0
    move $t1, $v0              # Save modFib(N-1) in $t1
    
    # Compute modFib(N-2)
    lw   $a0, 4($sp)           # Reload original N
    addi $a0, $a0, -2          # N - 2
    jal  modFib                # Returns in $v0
    
    # Sum results: modFib(N-1) + modFib(N-2)
    add  $v0, $v0, $t1
    
    # Restore and return
    lw   $t1, 0($sp)           # Restore $t1
    lw   $ra, 8($sp)           # Restore return address
    addi $sp, $sp, 12          # Restore stack pointer
    jr   $ra

returnF0:
    lw   $v0, F0               # Return F0
    jr   $ra

returnF1:
    lw   $v0, F1               # Return F1
    jr   $ra