#---------------------------------------------
#    Z = (A + B) + (C - D) + (E + F) - (A - C)
#---------------------------------------------
        .data
Z:      .word 0         # Reserve one word in memory for the result Z

        .text
        .globl main

main:
    # Load constants A-F into registers $t0 - $t5
    li   $t0, 15        # A
    li   $t1, 10        # B
    li   $t2, 7         # C
    li   $t3, 2         # D
    li   $t4, 18        # E
    li   $t5, -3        # F

    # Compute Z step by step using $t6 and $t7 as temp variable registers

    # $t6 = (A + B)
    addu $t6, $t0, $t1

    # $t7 = (C - D)
    subu $t7, $t2, $t3
    # add it to $t6
    addu $t6, $t6, $t7

    # $t7 = (E + F)
    addu $t7, $t4, $t5
    # add it to $t6
    addu $t6, $t6, $t7

    # $t7 = (A - C)
    subu $t7, $t0, $t2
    # subtract it from $t6
    subu $t6, $t6, $t7

    # Store final result Z from $t6 into memory
    la   $t8, Z         # Address of Z in data
    sw   $t6, 0($t8)    # Store Z

    # Exit the program
    li   $v0, 10        # Syscall code for exit
    syscall
