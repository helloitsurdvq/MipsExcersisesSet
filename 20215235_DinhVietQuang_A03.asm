#input N, print the prime number < N
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	err_print: .asciiz "No prime number!\n"
	message: .asciiz "Prime numbers less than N: "
	space: .asciiz " "
.text
init:
	li $t0, 0
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	add $t0, $zero, $v0 # store N into $t0
	
	ble $t0, $zero, printInvalid # check if N <= 0
	ble $t0, 2, printNoPrime # check if N <= 2
	li $v0, 4
	la $a0, message
	syscall
	li $t1, 1 # i = 1 
	j loop
	
printInvalid:
	li $v0, 4
	la $a0, err
	syscall
	j endMain

printNoPrime:
	li $v0, 4
	la $a0, err_print
	syscall
	j endMain

loop:
	addi $t1, $t1, 1
	bge $t1, $t0, endMain
	j checkPrime

checkPrime:
	li $t2, 1 # cnt = 1
	li $t3, 2 # j = 2
	loop_check_div: 
		bgt $t3, $t1, end_check_prime
		rem $t4, $t1, $t3
		beq $t4, $zero, divisible
		continue:
			addi $t3, $t3, 1
			j loop_check_div
		divisible: 
			addi $t2, $t2, 1
			j continue
	end_check_prime:
		bgt $t2, 2, notPrime
	isPrime:
		li $v0, 1
		add $a0, $zero, $t1
		syscall
	
		li $v0, 4
		la $a0, space
		syscall
	
		j loop
	notPrime:
		j loop

endMain:
	li $v0, 10
	syscall
