#input N -> print all squared number < N
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message: .asciiz "All squared number < N: "
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
	mul $t2, $t1, $t1 # i^2
	bge $t2, $t0, endMain # i^2 >= N => end loop
	
	li $v0, 1 # print i^2
	add $a0, $zero, $t2
	syscall
	addi $t1, $t1, 1
	
	li $v0, 4 # print space
	la $a0, space
	syscall
	
	j loop
	
endMain:
	li $v0, 10
	syscall
