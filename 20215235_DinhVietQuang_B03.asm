# print the pair of adjacent elements has the largest product in array
.data
	arr: .word 100
	A: .asciiz "Enter array size: "
	B: .asciiz "Enter the element: "
	output:	.asciiz "The pair of adjacent elements has the largest product is: "
	res: .asciiz "The maximum value: "
	space:	.asciiz " "
	line: "\n"
.text
main:
	li $v0, 4
	la $a0, A
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0  # Store value in $t0
	
# Insert array's elements
	li $t1, 0 # count element index
	la $t2, arr	
	li $v0, 4
	la $a0, B
	syscall
	
input:
	li $v0, 5
	syscall
	sw $v0, 0($t2)	# Save element's value into array
	
	addi $t1, $t1, 1 # +1 index
	addi $t2, $t2, 4 # +4 address
	
	beq $t1, $t0, start # if i == n => start
	j input

start:
	la $t2, arr # load array's address into $t2
	
	lw $s1, 0($t2) # Load A[i]
	lw $s2, 4($t2) # Load A[i+1]
	mul $t3, $s1, $s2 # A[i] * A[i+1]
	addi $t2, $t2, 4 # point to array's new address
	move $s4, $s1 # store $s1 into $s4
	move $s5, $s2 # store $s5 into $s2
	li $t1, 1 # increment (Equals to 1 because first one has already been counted)
	beq $t1, $t0, print # if array only containing 2 elements then jump to print

compare:
	lw $s1, 0($t2)
	lw $s2, 4($t2)
	mul $t4, $s1, $s2 # value of the product
	addi $t2, $t2, 4 # +4 address
	addi $t1, $t1, 1 # +1 index

	sgt $s3, $t4, $t3
	beq $t1, $t0, print
	beq $s3, 1, update_values # If A[i] * A[i+1] new is greater than older one, then update values
	j compare

	update_values:
		move $s4, $s1
		move $s5, $s2
		move $t3, $t4
		j compare

print: # print result
	li $v0, 4
	la $a0, output
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, res
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
endMain:
	li $v0, 10      
	syscall