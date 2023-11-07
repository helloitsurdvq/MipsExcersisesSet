# print the Pair of elements with smallest sum in array
.data
	A: .space 100
	message1: .asciiz "Enter array size: "
	message2: .asciiz "Enter element "
	res: .asciiz "Pair of elements with smallest sum: "
	space: .asciiz " "
	colon: .asciiz ": "
.text
main:
	la $s1, A  #s1: pointer = base address
input_size:
	li $v0, 4
	la $a0, message1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0   #s0: array size
	
	addi $t0, $s0, -2 #t0 = size - 2
	bltz $t0, input_size #size<2 => re input
	
	li $s2, 0 # i = 0	
input_elements:
	beq $s2, $s0, find_pair #i = size -> end input
	
	li $v0, 4
	la $a0, message2
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, colon
	syscall
	
	li $v0, 5
	syscall
	move $s3, $v0  #s3: curr element
	
	sw $s3, 0($s1) #A[i] = curr element
	addi $s1, $s1, 4
	addi $s2, $s2, 1
	
	j input_elements
find_pair:
	la $s1, A #s1: pointer
	add $s2, $s1, 4 #s2: next pointer
	
	li $t1, 0x7fffffff #smallest sum
	# $t2, $t3: pair of elements with smallest sum
	
	li $s3, 0 #i = 0
	li $s4, 0 #s4: curr element
	li $s5, 0 #s5: next element
	li $s6, 0 #s6: curr sum
	
	add $s7, $s0, -1 # s7 = size - 1
loop:
	beq $s3, $s7, end_loop #i = size - 1 ->end loop
	
	lw $s4, 0($s1)
	lw $s5, 0($s2)
	add $s6, $s4, $s5 #calculate curr sum
	
	slt $t0, $s6, $t1 # curr<smallest?
	beq $t0, $0, continue # curr>=smallest -> continue
	
	move $t1, $s6 #smallest = curr sum
	move $t2, $s4
	move $t3, $s5
continue:
	addi $s3, $s3, 1
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	
	j loop
end_loop:
	li $v0, 4
	la $a0, res
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
end_main:
	li $v0, 10
	syscall