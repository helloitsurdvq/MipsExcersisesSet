# print largest even element but smaller than every odd element
.data
	A: .space 100
	Aend: .word 
	Message1: .asciiz "Enter array size: "
	Message2: .asciiz "Enter the element: " 
	res: .asciiz "Found satisfied even: "
	noRes: .asciiz "No even element found."
	ms: .asciiz " "
	line: .asciiz "\n"
.text
main: 	
	li $s0, -999999 # result - largest even
	li $s1, 999999 # smallest odd
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

countInit:
	la $s4, ($t0) # get size of list
	move $s5, $zero # set counter for # of elems printed
	move $s6, $zero # set offset from Array

loopFoundMinOdd: # find the min odd element
	bge $s5, $s4, resetInit
	lw $s7, A($s6) # A[i] 
	rem $t2, $s7, 2 # check odd
	bnez $t2, checkMinOdd
	addi $s5, $s5, 1
	addi $s6, $s6, 4
	j loopFoundMinOdd
	checkMinOdd:
		blt $s7, $s1, updateMinOdd
		addi $s5, $s5, 1
		addi $s6, $s6, 4
		j loopFoundMinOdd
		updateMinOdd:
			move $s1, $s7 # $s1 is min odd value
			addi $s5, $s5, 1
			addi $s6, $s6, 4
			j loopFoundMinOdd	 

resetInit: # reset the index and address for further work
	li $s5, 0 # set counter for # of elems printed
	li $s6, 0 # set offset from Array
	li $t8, 0 # count odd element
checkOdd:
	bge $s5, $s4, doneCheck
	lw $s7, A($s6) # A[i] 
	rem $t2, $s7, 2 # check odd
	bnez $t2, countOdd
	addi $s5, $s5, 1
	addi $s6, $s6, 4
	j checkOdd
	countOdd:
		addi $t8, $t8, 1
		addi $s5, $s5, 1
		addi $s6, $s6, 4
		j checkOdd
		
doneCheck:
checkfullOdd:
	beq $t8, $s4, printInvalid
	j resetInitforCount
	printInvalid:
		li $v0, 4
		la $a0, noRes
		syscall
		j endMain	

resetInitforCount: # reset the index and address for further work
	li $s5, 0 # set counter for # of elems printed
	li $s6, 0 # set offset from Array

loopMaxEven:
	bge $s5, $s4, printResult
	lw $s7, A($s6) # A[i] 
	rem $t2, $s7, 2
	beqz $t2, checklessEven
	addi $s5, $s5, 1
	addi $s6, $s6, 4
	j loopMaxEven
	checklessEven:
		blt $s7, $s1, checkMaxEven # check if the even element < smallest odd element
		addi $s5, $s5, 1
		addi $s6, $s6, 4
		j loopMaxEven
		checkMaxEven:
			bgt $s7, $s0, updateMaxEven # find the largest even element < smallest odd element
			addi $s5, $s5, 1
			addi $s6, $s6, 4
			j loopMaxEven
			updateMaxEven: # update result
				move $s0, $s7
				addi $s5, $s5, 1
				addi $s6, $s6, 4
				j loopMaxEven

printResult:
	li $v0, 4
	la $a0, res
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall

endMain: 
	li $v0, 10 #exit
 	syscall
