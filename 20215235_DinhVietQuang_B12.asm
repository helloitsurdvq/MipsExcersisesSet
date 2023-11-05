# add an element in an sorted array but keep the ascending order of an array
.data
	A: .space 100
	message1: .asciiz "Enter array size: "
	message2: .asciiz "Enter element "
	message3: .asciiz "Enter new element: "
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
	li $s3, 0x80000000 #prev = -2^31	
input_elements:
	beq $s2, $s0, input_new #i = size -> end input
	
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
	slt $t0, $v0, $s3 #curr < prev ?
	bne $t0, $0, input_elements #curr < prev -> re input
	
	move $s3, $v0  #s3: curr element
	
	sw $s3, 0($s1) #A[i] = curr element
	addi $s1, $s1, 4
	addi $s2, $s2, 1
	
	j input_elements
input_new:
	li $v0, 4
	la $a0, message3
	syscall
	
	li $v0, 5
	syscall
	move $s3, $v0 #s3: new element
print_result:
	la $a0, A
	move $a1, $s0
	move $a2, $s3 
	jal insert
	
	li $v0, 4
	la $a0, res
	syscall 
	
	la $s1, A  #pointer
	li $s2, 0  #i
	addi $s0, $s0, 1 #size++
print_loop:
	beq $s2, $s0, end_main
	
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

#Function void insert(int* arr, int size, int new)
#C code
#void insert(int* arr, int size, int new){
#    int i=0;
#    for (; i<size; i++){
#        if (new<arr[i]) break;
#    }
#    // i is the postion of new element
#    for (int j=size; j>i; j--){
#        arr[j] = arr[j-1];
#    }
#    arr[i] = new;
#}

insert:
	li $t1, 0 #i=0
find_loop:
	beq $t1, $a1, end_find_loop # i = size -> end_find_loop
	
	add $t2, $t1, $t1
	add $t2, $t2, $t2
	add $t2, $t2, $a0
	lw $t3, 0($t2) #arr[i]
	
	slt $t0, $a2, $t3 #new < arr[i] ?
	bne $t0, $0, end_find_loop # new < arr[i] -> break
	
	addi $t1, $t1, 1
	j find_loop
end_find_loop:
	move $t4, $a1 #j = size
move_loop:
	beq $t4, $t1, end_move_loop #j = i -> end_move_loop
	
	add $t2, $t4, $t4
	add $t2, $t2, $t2
	add $t2, $t2, $a0  # address of A[j]
	add $t5, $t2, -4   # address of A[j-1]
	lw $t3, 0($t5) #A[j-1]
	sw $t3, 0($t2) #A[j] = A[j-1]
	
	addi $t4, $t4, -1 #j--
	j move_loop
end_move_loop:
	add $t2, $t1, $t1
	add $t2, $t2, $t2
	add $t2, $t2, $a0
	sw $a2, 0($t2) #A[i] = new
end_function:
	jr $ra
	