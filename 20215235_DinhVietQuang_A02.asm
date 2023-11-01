#input N, print the fibo number < N
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message: .asciiz "Fibonacci numbers less than N: "
	space: .asciiz " "
.text
init: 
	li $t0, 0 # init N
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	li $t1, 1 # i = 1
	li $s0, 0 # F(0)
	li $s1, 1 # F(1)
	
	li $v0, 4
	la $a0, message
	syscall
	j loop
	
printInvalid:
	li $v0, 4
	la $a0, err
	syscall
	j endMain

loop:
	bge $s0, $t0, endMain # Check i < N
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	add $t1, $s0, $s1 # F(n) = F(n-1) + F(n-2)
	move $s0, $s1
	move $s1, $t1
	j loop

endMain:
	li $v0, 10
	syscall
