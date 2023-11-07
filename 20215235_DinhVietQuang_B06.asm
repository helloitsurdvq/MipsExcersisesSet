.data
	A: .space 100
	negative: .space 100
	negativeId: .space 100
	promptN: .asciiz "Enter array size: "
	promptInput: .asciiz "Enter the element: "
	output:	.asciiz "The array now is: "
	error: .asciiz "Error input."
	space:	.asciiz " "
	line: "\n"
.text
#$s0, $s1: i,j for loop
main:
	li $v0, 4
	la $a0, promptN
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0  # $t0 = size of array
	
	ble $t0, $zero, printInvalid
	
# Insert array's elements
	la $t1, A
	la $t2, negative
	la $t3, negativeId
	li $s2, 0 # $s2 = size of negative
	li $v0, 4
	la $a0, promptInput
	syscall
	
	li $s0, 0 
input:
	li $v0, 5
	syscall
	sw $v0, 0($t1)	# Save element's value into array
	addi $t1, $t1, 4 # $t1 = addr(A[n])
	
	bgez $v0, not_neg
	sw $v0, 0($t2)	# Save element's value into negative
	add $t2, $t2, 4
	sw $s0, 0($t3)	# Save element's value into negativeId
	add $t3, $t3, 4
	add $s2, $s2, 1 
	
not_neg: 
	addi $s0, $s0, 1 
	beq $s0, $t0, sortNeg # if i == n => start
	j input

sortNeg: # increasing
	beq $s2, 1, endSortNeg	                              
outerLoopNeg:            
    la  $s0, negative	         		# $s0 = addr(negative[0])
    mul $t6, $s2, 4
    add $t5, $s0, $t6
    addi $t5, $t5, -4		 # %$t5 = addr(negative[N-1])
    add $s1, $zero, $zero	 # $s1 holds a flag to determine when the list is sorted
innerLoopNeg:                    # The inner loop will iterate over the array checking if a swap is needed
    lw  $t2, 0($s0)           
    lw  $t3, 4($s0)           
    slt $t4, $t3, $t2         # $t4 = 1 if $t2 > $t3
    bne $t4, $zero, continueNeg	  # if $t4 = 1, then swap them
    add $s1, $zero, 1         # if we need to swap, we need to check the list again
    sw  $t2, 4($s0)          
    sw  $t3, 0($s0)          
continueNeg:
    addi $s0, $s0, 4            # i++
    bne  $s0, $t5, innerLoopNeg    # If $s0 != the end of Array, jump back to innerLoop
    bne  $s1, $zero, outerLoopNeg  # $s1 = 1, another pass is needed, jump back to outerLoop	

endSortNeg:

	la $s0, 0
	la $t2, negative
	la $t3, negativeId
	la $t4, A
assign_loop:
	beq $s0, $s2, after_assign_loop
	mul $t5, $s0, 4
	add $t2, $t2, $t5
	add $t3, $t3, $t5 
	lw $t6, 0($t2)
	lw $t7, 0($t3)
	mul $t5, $t7, 4
	add $t4, $t4, $t5
	sw $t6, 0($t4)
	la $t2, negative
	la $t3, negativeId
	la $t4, A
	addi $s0, $s0, 1
	j assign_loop

after_assign_loop:
    la $s0, A # i = addr(A{i])
    li $v0, 4
	la $a0, output
	syscall
	
print_output: # array
	beq $s0, $t1, after_print_output
	
	li $v0, 1
	lw $a0, 0($s0)
	syscall # print A[i]
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s0, $s0, 4
	j print_output
	 
after_print_output:
    li $v0, 10
    syscall
    
printInvalid:
	li $v0, 4
	la $a0, error
	syscall
	j after_print_output
