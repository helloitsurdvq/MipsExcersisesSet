# sort the array so that all positive elements are positioned before negative elements
.data
	A: .space 100
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
	li $v0, 4
	la $a0, res
	syscall
	
	la $a0, A
	move $a1, $s0
	jal swap
	
	la $s1, A #pointer
	li $s2, 0 #i=0
print_elements:
	beq $s2, $s0, end_main  # i = size -> end main
	
	li $v0, 1
	lw $a0, 0($s1)
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s2, $s2, 1
	addi $s1, $s1, 4
	j print_elements
end_main:
	li $v0, 10
	syscall

#Function swap
#C code
#void swap(int* arr, int size){
#    int i=0, j=size-1;
#    while (i<j){
#        if (arr[i]<0){
#           while (arr[j] < 0 && j>i) j--;
#            int temp = arr[i];
#            arr[i] = arr[j];
#            arr[j] = temp;
#        }
#        i++;
#    }
#}

swap:
	li $t1, 0 #i=0
	addi $t2, $a1, -1 #j=size-1
loop1:
	slt $t0, $t1, $t2 # i<j?
	beq $t0, $0, end_loop1 #i>=j -> end loop1
	
	add $t3, $t1, $t1
	add $t3, $t3, $t3
	add $t3, $t3, $a0 
	lw $t4, 0($t3)  #t4: arr[i]
	
	bgez $t4, continue_loop1 #arr[i] >= 0 -> continue
	
loop2:	
	add $t5, $t2, $t2
	add $t5, $t5, $t5
	add $t5, $t5, $a0 
	lw $t6, 0($t5) #t6: arr[j]
	
	bgez $t6, end_loop2 #arr[j]>=0 -> end loop2
	
	slt $t0, $t1, $t2  #i<j?
	beq $t0, $0, end_loop2 #i>=j -> end loop2
	
	addi $t2, $t2, -1 #j--
	j loop2
end_loop2:
	sw $t4, 0($t5)  #arr[j] = arr[i]
	sw $t6, 0($t3)  #arr[i] = arr[j]
continue_loop1:
	addi $t1, $t1, 1
	j loop1
end_loop1:
	jr $ra