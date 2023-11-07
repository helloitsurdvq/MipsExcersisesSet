# Find and print the largest integer divisible by N and less than M
.data
	promptM: .asciiz "Enter M: "
	promptN: .asciiz "Enter N: "
	error: .asciiz "Invalid input."
	message: .asciiz "Output: "
.text
init:
 
	li $t0, 0
	li $t1, 0 #init M, N
main:

	li $v0, 4 
	la $a0, promptM
	syscall
	
	li $v0, 5 # input M
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	
	li $v0, 4 
	la $a0, promptN
	syscall
	
	li $v0, 5 # input N
	syscall
	add $t1, $zero, $v0
	
	ble $t1, $zero, printInvalid
	ble $t0, $t1, printInvalid
	
	add $t2, $t1, $zero # i
loop:
	bge $t2, $t0, end_loop
	add $t2, $t2, $t1 
	j loop
	
end_loop: 
	sub $t2, $t2, $t1
	
	li $v0, 4
	la $a0, message
	syscall 
	
	li $v0, 1
	add $a0, $t2, $zero
	syscall # print ans
	j endMain
printInvalid:

	li $v0, 4
	la $a0, error
	syscall
	j endMain
endMain:

	li $v0, 10
	syscall
