# print the most-frequency element in array
.data
	A: .space 100
	message1: .asciiz "Enter array size: "
	message2: .asciiz "Enter element "
	res: .asciiz "Most frequent element: "
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
	beq $s2, $s0, print_result #i = size -> end input
	
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
print_result:
	la $a0, A
	move $a1, $s0
	jal findMostFrequent
	
	li $v0, 4
	la $a0, res
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
end_main:
	li $v0, 10
	syscall

#Function int findMostFrequent(int* arr, int size)
findMostFrequent:
	li $s2, 0 #i = 0
	li $t1, 0 # maxCount = 0
	li $t2, 0 # most frequent element
loop1:
	beq $s2, $a1, end_loop1 # i = size -> end loop 1
	
	li $t3, 1 # currCount = 1
	add $s3, $s2, $s2
	add $s3, $s3, $s3
	add $s3, $s3, $a0 # s3 = address of arr[i]
	lw $s4, 0($s3) # s4 = arr[i]
	
	addi $s5, $s2, 1 # j = i + 1
loop2:	
	beq $s5, $a1, end_loop2 #j = size -> end loop 2
	
	add $s6, $s5, $s5
	add $s6, $s6, $s6
	add $s6, $s6, $a0 # s6= address of arr[j]
	lw $s7, 0($s6) #s7 = arr[j]
	
	bne $s4, $s7, continue_loop2 #a[i] <> a[j] -> continue
	
	addi $t3, $t3, 1	
continue_loop2:
	addi $s5, $s5, 1
	j loop2
end_loop2:
	slt $t0, $t1, $t3 #maxCount < currCount?
	beq $t0, $0, continue_loop1 #maxCount >= currCount -> continue
	
	move $t1, $t3 # update maxCount
	move $t2, $s4 # update most frequent element
continue_loop1:
	addi $s2, $s2, 1 
	j loop1
end_loop1:
	jr $ra