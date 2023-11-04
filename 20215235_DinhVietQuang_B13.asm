# count the number of distinct elements in arrays
.data
	A: .space 100
	Aend: .word 
	Message1: .asciiz "Enter array size: "
	Message2: .asciiz "Enter the element: " 
	res: .asciiz "Distinct numbers count: "
	ms: .asciiz " "
	line: .asciiz "\n"

.text
main: 	
	la $a3, A # address of A
 	j insert

insert: 
	li $v0, 4 
	la $a0, Message1
	syscall
	
	li $v0, 5 # read n
	syscall
	la $s0, ($v0) # temp save the length of array A (n = $t0)
	li $s1, 0 # i = 0
	
loop_insert: # input array element
	beq $s1, $s0, after_insert
	li $v0, 4
	la $a0, Message2
	syscall

	li $v0, 5
	syscall
	
	sw $v0, 0($a3)
	addi $s1, $s1, 1
	add $a3, $a3, 4
	j loop_insert

after_insert:
	li $t0, 0 # i = 0
	li $t1, 0 # j = 0
	la $t2, A # get size of list
	la $t3, A # set counter for # of elems printed
loop:
	bge $t0, $s0, printResult # for(i = 0; i < n; i++)
	li $t1, 0 # after each i loop, we reset j = 0
	la $t3, A # get address of A[j]
	lw $t4, 0($t2) # load A[i]
	loopj:
		bge $t1, $t0, compareIandJ # for(j = 0; j < i; j++)
		lw $t5, 0($t3) # load A[j]
		beq $t4, $t5, compareIandJ # if(a[i] == a[j]) break;
		addi $t1, $t1, 1 # j++
		addi $t3, $t3, 4 # increase j address
		j loopj
	compareIandJ:
		beq $t1, $t0, addCnt
		j continue
		addCnt:
			addi $s2, $s2, 1 # cnt++
			j continue
	continue:
		addi $t0, $t0, 1 # i++
		addi $t2, $t2, 4 # increse i address
		j loop

printResult:
	li $v0, 4
	la $a0, res # print sumEven
	syscall
	
	li $v0, 1
	move $a0, $s2 # cnt = $s2
	syscall
	
endMain: # exit
	li $v0, 10
	syscall