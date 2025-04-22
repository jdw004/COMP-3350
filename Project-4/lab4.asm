.data
Z: .word 0 
.text
.globl main
main:
  lw $t4, Z        # Load Z 
  li $t5, 1        # Load 1 into $t5 
  beq $t4, $t5, case_1 # if Z == 1, go to case_1
  li $t5, 2        # Load 2 into $t5
  beq $t4, $t5, case_2 # if Z == 2, go to case_2
  j default_case   # default
case_1:
  li $t4, -1 
  sw $t4, Z 
  j end
case_2:
  li $t4, -2 
  sw $t4, Z 
  j end 
default_case:
  li $t4, 0 
  sw $t4, Z 
end:
  # Exit
  li $v0, 10 
  syscall
