# check if a, b, c is Isosceles triangle or triangle
.data
	prompt: .asciiz "Enter a positive integer: "
	error: .asciiz "Invalid input."
	message1: .asciiz "Not a triangle."
	message2: .asciiz "Triangle."
	message3: .asciiz "Isosceles triangle."
.text
init:
 
	li $t0, 0
	li $t1, 0
	li $t2, 0 # init A, B, C
main:

	li $v0, 4 
	la $a0, prompt
	syscall
	
	li $v0, 5 # input A
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	
	li $v0, 4 
	la $a0, prompt
	syscall
	
	li $v0, 5 # input B
	syscall
	add $t1, $zero, $v0
	
	ble $t1, $zero, printInvalid
	
	li $v0, 4 
	la $a0, prompt
	syscall
	
	li $v0, 5 # input C
	syscall
	add $t2, $zero, $v0
	
	ble $t2, $zero, printInvalid
	
sort: # increasing array
 
	slt $t3, $t0, $t1
	bne $t3, $zero, after_swap1
	add $t3, $t0, $zero
	move $t0, $t1
	move $t1, $t3
after_swap1:

	slt $t3, $t1, $t2
	bne $t3, $zero, after_swap2
	add $t3, $t1, $zero
	move $t1, $t2
	move $t2, $t3
after_swap2:

	slt $t3, $t0, $t1
	bne $t3, $zero, after_swap3
	add $t3, $t0, $zero
	move $t0, $t1
	move $t1, $t3
after_swap3:
	
	beq $t0, $t1, isosceles
	beq $t1, $t2, isosceles
	add $t3, $t0, $t1
	ble $t3, $t2, not_triangle
	li $v0, 4
	la $a0, message2
	syscall 
	j endMain
not_triangle:
	li $v0, 4
	la $a0, message1
	syscall 
	j endMain
isosceles:
	li $v0, 4
	la $a0, message3
	syscall 
	j endMain
printInvalid:
	li $v0, 4
	la $a0, error
	syscall
	j endMain
endMain:
	li $v0, 10
	syscall