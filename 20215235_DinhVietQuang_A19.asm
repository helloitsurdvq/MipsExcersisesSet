#input N, print the smallest prime numbers greater than N
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	err_print: .asciiz "No prime number!\n"
	message: .asciiz "The smallest prime numbers greater than N: "
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
	addi $t1, $t0, 1 # i = N + 1
	li $t5, 1 # boolean 
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
	beqz $t5, isPrime # while true => keep going, else break
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
	
		li $t5, 0 # break
		j endMain
	notPrime:
		j loop

endMain:
	li $v0, 10
	syscall