# delete element at position k in array
.data
	A: .space 100
	message1: .asciiz "Enter array size: "
	message2: .asciiz "Enter element "
	message3: .asciiz "Enter position k (0<=k<=size-1): "
	res: .asciiz "Modified array: "
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
	
	slt $t0, $0, $s0 
	beq $t0, $0, input_size #size<=0 => re input
	
	li $s2, 0 # i = 0	
input_elements:
	beq $s2, $s0, input_k #i = size -> end input
	
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
input_k:
	li $v0, 4
	la $a0, message3
	syscall
	
	li $v0, 5
	syscall
	move $s3, $v0 #s3: k
	
	bltz $s3, input_k # k < 0 -> reinput
	slt $t0, $s3, $s0 # k < size
	beq $t0, $0, input_k # k>=size -> reinput
delete:
	la $s1, A #s0: base address
	addi $s4, $s0, -1 # s4 = size - 1
	move $s2, $s3 # i = k
loop:
	beq $s2, $s4, end_loop # i = size - 1 -> end loop
	
	add $s5, $s2, $s2
	add $s5, $s5, $s5
	add $s5, $s5, $s1  #address of A[i]
	add $s6, $s5, 4 #address of A[i+1]
	lw $s7, 0($s6) #A[i+1]
	sw $s7, 0($s5) #A[i]=A[i+1]
	
	addi $s2, $s2, 1
	j loop
end_loop:
	addi $s0, $s0, -1 #size--
print_result:
	li $v0, 4
	la $a0, res
	syscall
	
	li $s2, 0 # i = 0
	la $s1, A
print_loop:
	beq $s2, $s0, end_main # i = size -> end main
	
	li $v0, 1
	lw $a0, 0($s1) 
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s2, $s2, 1
	addi $s1, $s1, 4
	j print_loop
end_main:
	li $v0, 10
	syscall