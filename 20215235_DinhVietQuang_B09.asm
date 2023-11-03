# print the minimum positive element in array
.data
	A: .space 100
	Aend: .word 
	Message1: .asciiz "Enter array size: "
	Message2: .asciiz "Enter the element: " 
	res: .asciiz "Minimum positive element: "
	ms: .asciiz " "
	line: .asciiz "\n"
.text
main: 	
	li $s1, 999999 # minValue
	la $a3, A # address of A
 	j insert
 	
insert: 
	li $v0, 4 
	la $a0, Message1
	syscall
	
	li $v0, 5 # read n
	syscall
	la $t0, ($v0) # temp save the length of array A (n = $t0)
	li $t1, 0 # i = 0
	
loop_insert: # input array element
	beq $t1, $t0, after_insert
	li $v0, 4
	la $a0, Message2
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 0($a3)
	addi $t1, $t1, 1
	add $a3, $a3, 4
	j loop_insert
	
after_insert:
	la $a0, A
	la $a1, Aend # re-assign the element nums to $a1
	mul $t3, $t0, 4
	add $a1, $a0, $t3
	add $a1, $a1, -4
	
printInit:
	la $t4, ($t0) # get size of list
	move $t5, $zero # set counter for # of elems printed
	move $t6, $zero # set offset from Array

print_loop:
	bge $t5, $t4, print_loop_end # stop after last elem is printed
	lw $a0, A($t6) # print next value from the list
	
	li $v0, 1
	syscall
	
	la $a0, ms # print a newline
	li $v0, 4
	syscall
	
	addi $t5, $t5, 1 # increment the loop counter
	addi $t6, $t6, 4 # step to the next array element
	j print_loop # repeat the loop

print_loop_end: # print new line
	li $v0, 4
	la $a0, line
	syscall

countInit:
	la $s4, ($t0) # get size of list
	move $s5, $zero # set counter for # of elems printed
	move $s6, $zero # set offset from Array

loop:
	bge $s5, $s4, printResult# stop after last elem is printed
	lw $s7, A($s6) # next value from the list (A[i])
	
	bgtz $s7, checkPositive #check if A[i] > 0
	addi $s5, $s5, 1 # increment the loop counter
	addi $s6, $s6, 4 # step to the next array element
	j loop
	checkPositive:
		blt $s7, $s1, checkMinPos #check if A[i] < current min value
		addi $s5, $s5, 1 # increment the loop counter
		addi $s6, $s6, 4 # step to the next array element
		j loop
		checkMinPos: 
			move $s1, $s7 # update min Value
			addi $s5, $s5, 1 # increment the loop counter
			addi $s6, $s6, 4 # step to the next array element
			j loop
	
printResult:
	li $a0, 4
	la $a0, res
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall

endMain: 
	li $v0, 10 #exit
 	syscall
