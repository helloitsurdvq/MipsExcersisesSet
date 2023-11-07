# input array size n, M, N, count the number of elements not in range (M, N)
.data
	A: .space 100
	Aend: .word 
	Message1: .asciiz "Enter array size: "
	Message2: .asciiz "Enter the element: " 
	inputM: .asciiz "Enter M: "
	inputN: .asciiz "Enter N: "
	res: .asciiz "Count elements in range [M, N]: "
	ms: .asciiz " "
	line: .asciiz "\n"
.text
main: 	
	li $s0, 0 # cnt = 0
	li $s1, 0 # init M
	li $s2, 0 # init N
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

inputRange:
	li $v0, 4
	la $a0, inputM
	syscall
	
	li $v0, 5 # read M
	syscall
	add $s1, $zero, $v0 
	
	li $v0, 4
	la $a0, inputN
	syscall
	
	li $v0, 5 # read N
	syscall
	add $s2, $zero, $v0

countInit:
	la $s4, ($t0) # get size of list
	move $s5, $zero # set counter for # of elems printed
	move $s6, $zero # set offset from Array

loop:
	bge $s5, $s4, printResult# stop after last elem is printed
	lw $s7, A($s6) # next value from the list (A[i])
	
	bgt $s7, $s2, nextElement  # Skip elements not less than or equal to N
    	blt $s7, $s1, nextElement  # Skip elements less than M
    	addi $s0, $s0, 1 # increase cnt if satify the condition
    	
    	addi $s5, $s5, 1 # increment the loop counter
	addi $s6, $s6, 4 # step to the next array element
	j loop
	
	nextElement:
		addi $s5, $s5, 1 # increment the loop counter
		addi $s6, $s6, 4 # step to the next array element
		j loop # repeat the loop

printResult:
	li $v0, 4
	la $a0, res
	syscall
	
	sub $t8, $t0, $s0
	
	li $v0, 1 # print result
	move $a0, $t8 
	syscall

endMain: 
	li $v0, 10 #exit
 	syscall
