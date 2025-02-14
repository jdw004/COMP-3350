        .data
# Store A, B, C, Z in memory
A: .word 10
B: .word 15
C: .word 6
Z: .word 0

        .text
        .globl main

main:

    # Load A, B, C, Z from memory into registers
    la   $a0, A         # Address of A
    lw   $s0, 0($a0)    # $s0 = A

    la   $a1, B         # Address of B
    lw   $s1, 0($a1)    # $s1 = B

    la   $a2, C         # Address of C
    lw   $t0, 0($a2)    # $t0 = C

    la   $v1, Z         # Address of Z
    lw   $s3, 0($v1)    # $s3 = Z should be 0 at first


    # if (A > B || C < 5)          Z = 1
    # else if (A > B && (C+1)==7)  Z = 2
    # else                         Z = 3


    # Check A > B
    sub  $t4, $s0, $s1    # t4 = A - B
    bgtz $t4, IF_1        # if (A - B) > 0 => A > B => jump

    # Check C < 5
    slti $t5, $t0, 5      # t5=1 if s2 < 5
    bne  $t5, $zero, IF_1 # if (C < 5) => jump to IF_1

    # If neither condition check second if
    # else if (A>B && (C+1)==7)
    bgtz $t4, IF_2_2 # if (A > B) => continue
    j    ELSE             # otherwise => Z=3

IF_2_2:
    addi $t6, $t0, 1      # (C + 1)
    li   $t7, 7
    beq  $t6, $t7, IF_2   # if (C+1)==7 => jump
    j    ELSE

# True branch of first if => Z=1
IF_1:
    li   $s3, 1
    j    SWITCH

# True branch of second if => Z=2
IF_2:
    li   $s3, 2
    j    SWITCH

# else => Z=3
ELSE:
    li   $s3, 3

    # switch Z

SWITCH:
    li   $t8, 1
    beq  $s3, $t8, CASE_1
    li   $t8, 2
    beq  $s3, $t8, CASE_2
    j    DEFAULT

CASE_1:
    li   $s3, -1
    j    END_SWITCH

CASE_2:
    li   $s3, -2
    j    END_SWITCH

DEFAULT:
    li   $s3, 0

END_SWITCH:
    # Store final Z from register back into memory
    la   $s4, Z
    sw   $s3, 0($s4)

    # Exit the program
    li   $v0, 10
    syscall