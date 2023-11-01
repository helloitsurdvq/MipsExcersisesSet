# print min element but larger than every even element
.data
	A: .space 100
	Aend: .word 
	Message1: .asciiz "Enter array size: "
	Message2: .asciiz "Enter the element: " 
	res: .asciiz "Found satisfied odd: "
	noRes: .asciiz "No odd element found."
	ms: .asciiz " "
	line: .asciiz "\n"
.text
main: 	
	li $s0, -999999 # result - smallest odd even
	li $s1, 999999 # biggest even number
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

loopFoundMinEven: # find the min Even element
	bge $s5, $s4, resetInit
	lw $s7, A($s6) # A[i] 
	rem $t2, $s7, 2 # check even
	beqz $t2, checkMinEven
	addi $s5, $s5, 1
	addi $s6, $s6, 4
	j loopFoundMinEven
	checkMinEven:
		blt $s7, $s1, updateMinEven
		addi $s5, $s5, 1
		addi $s6, $s6, 4
		j loopFoundMinEven
		updateMinEven:
			move $s1, $s7 # $s1 is min even value
			addi $s5, $s5, 1
			addi $s6, $s6, 4
			j loopFoundMinEven	 

resetInit: # reset the index and address for further work
	li $s5, 0 # set counter for # of elems printed
	li $s6, 0 # set offset from Array
	li $t8, 0 # count Even element
checkEven:
	bge $s5, $s4, doneCheck
	lw $s7, A($s6) # A[i] 
	rem $t2, $s7, 2 # check even
	beqz $t2, countEven
	addi $s5, $s5, 1
	addi $s6, $s6, 4
	j checkEven
	countEven:
		addi $t8, $t8, 1
		addi $s5, $s5, 1
		addi $s6, $s6, 4
		j checkEven
		
doneCheck:
checkfullEven:
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

loopMaxOdd:
	bge $s5, $s4, printResult
	lw $s7, A($s6) # A[i] 
	rem $t2, $s7, 2
	bnez $t2, checklessOdd
	addi $s5, $s5, 1
	addi $s6, $s6, 4
	j loopMaxOdd
	checklessOdd:
		blt $s7, $s1, checkMaxOdd # check if the odd element < smallest even element
		addi $s5, $s5, 1
		addi $s6, $s6, 4
		j loopMaxOdd
		checkMaxOdd:
			bgt $s7, $s0, updateMaxOdd # find the largest odd element < smallest even element
			addi $s5, $s5, 1
			addi $s6, $s6, 4
			j loopMaxOdd
			updateMaxOdd: # update result
				move $s0, $s7
				addi $s5, $s5, 1
				addi $s6, $s6, 4
				j loopMaxOdd

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