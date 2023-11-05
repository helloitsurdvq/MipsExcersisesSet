# sort all positive element in ascending order in an array
.data
	A: .space 100
	positive: .space 100
	message1: .asciiz "Enter array size: "
	message2: .asciiz "Enter element "
	res: .asciiz "Sorted array: "
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
	beq $s2, $s0, sort_positive #i = size -> end input
	
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
sort_positive:
	la $s1, A # s1 : pointer of A
	li $s2, 0 # s2 : index of A
	
	la $s3, positive # s3: pointer of positive array
	li $s4, 0 # s4 : index of positive
copy_loop:
	beq $s2, $s0, end_copy_loop  # i = size -> end copy loop
	
	lw $s5, 0($s1) # s5 = A[i]
	blez $s5, continue # A[i] <= 0 -> continue
	
	sw $s5, 0($s3) #positive[j] = A[i]
	addi $s4, $s4, 1
	addi $s3, $s3, 4
continue:
	addi $s1, $s1, 4
	addi $s2, $s2, 1
	
	j copy_loop
end_copy_loop:
	la $a0, positive  #a0: base address of positive array
	move $a1, $s4   #a1: size of positive array
	jal bubble_sort
after_sort:
	la $s1, A # s1 : pointer of A
	li $s2, 0 # s2 : index of A
	
	la $s3, positive # s3: pointer of positive array
	li $s4, 0 # s4 : index of positive
	
	li $v0, 4 
	la $a0, res  
	syscall  #print string
copy_back_loop:
	beq $s2, $s0, end_main # i = size -> end print
	
	lw $s5, 0($s1) #s5 = A[i]
	blez $s5, continue_copy_back_loop #A[i] <= 0 -> continue
	
	lw $s6, 0($s3) #s6 = positive[j]
	sw $s6, 0($s1) #A[i] = positive[j]
	
	addi $s3, $s3, 4
continue_copy_back_loop:
	li $v0, 1
	lw $s5, 0($s1)
	move $a0, $s5
	syscall #print new A[i]
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s1, $s1, 4
	addi $s2, $s2, 1
	
	j copy_back_loop
end_main:
	li $v0, 10
	syscall	
	
	
#Function void bubble_sort(int* positive, int size)
bubble_sort:
	li $t1, 0 # i = 0
	addi $t3, $a1, -1 #t3 = size - 1
loop1:
	beq $t1, $t3, end_loop1 #i = size-1 -> end loop1
	
	li $t2, 0 #j = 0
	sub $t4, $t3, $t1 # t4 = size - 1 - i
loop2:
	beq $t2, $t4, end_loop2 #j = size - 1 - i -> end loop 2
	
	add $t5, $t2, $t2
	add $t5, $t5, $t5
	add $t5, $t5, $a0 #t5 = address of A[j]
	lw $t6, 0($t5) # t6 = A[j]
	lw $t7, 4($t5) # t7 = A[j+1]
	slt $t0, $t7, $t6 # A[j+1]<A[j]?
	bne $t0, $0, swap #A[j+1]<A[j] -> swap
	
	j continue_loop_2
swap:
	sw $t6, 4($t5) # A[j+1] = A[j]
	sw $t7, 0($t5) # A[j] = A[j+1]
continue_loop_2:
	addi $t2, $t2, 1
	j loop2
end_loop2:
	addi $t1, $t1, 1 #i++
	j loop1
end_loop1:	
	jr $ra	