# input N -> print the largest digit in N

.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message: .asciiz "Largest digit in N: "
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
	li $t1, 0 # largest = 0
	
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
	blez $t0, printLowest
	rem $t3, $t0, 10 #digit = N % 10
	bgt $t3, $t1, update # if digit > $t1 => update
	ble $t3, $t1, continue
	update: 
		move $t1, $t3
		div $t0, $t0, 10
		j loop
	continue:
		div $t0, $t0, 10
		j loop

printLowest:
	li $v0, 1
	add $a0, $zero, $t1
	syscall

endMain: 
	li $v0, 10
	syscall
