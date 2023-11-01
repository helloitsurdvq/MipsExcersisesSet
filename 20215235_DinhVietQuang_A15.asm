# print the GCD of M and N
.data
	promptM: .asciiz "Enter a positive integer M: "
	promptN: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message: .asciiz "GCD: "
	space: .asciiz " "
	
.text
init: 
	li $t0, 0 # init M
	li $t1, 0 # init N
	li $t2, 0 # GCD
main:
	li $v0, 4
	la $a0, promptM
	syscall
	
	li $v0, 5
	syscall
	add $t0, $zero, $v0
	
	li $v0, 4
	la $a0, promptN
	syscall
	
	li $v0, 5
	syscall
	add $t1, $zero, $v0
	
	ble $t0, $zero, printInvalid
	ble $t1, $zero, printInvalid
	
	li $v0, 4
	la $a0, message
	syscall
	j findGCD

printInvalid:
	li $v0, 4
	la $a0, err
	syscall
	j endMain
	
findGCD:
	beqz $t1, printResult
	move $t3, $t1 # temp = $t3
	rem $t4, $t0, $t1 # b = a % b;
	move $t1, $t4 
	move $t0, $t3 # a = temp;
	j findGCD

printResult:
	move $t2, $t0 # assign a = GCD after loop
	
	li $v0, 1 # print GCD
	move $a0, $t2
	syscall

endMain:
	li $v0, 10
	syscall