# input N, base 10(decimal) -> base 8 (octal)
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message: .asciiz "Octal conversion: "
	space: .asciiz " "
.text
init: 
	li $t0, 0 # init N
main:
	li $v0, 4 
	la $a0, prompt
	syscall
	
	li $v0, 5 # input N
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	li $t1, 0 # init res = 0
	li $t2, 1 # countVal = 1
		
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
	beqz $t0, printOctal # n == 0 => out
	rem $t3, $t0, 8 # rem = n % 8
	mul $t4, $t3, $t2 # $t4 = rem * countVal
	add $t1, $t1, $t4 # res = res + $t4
	mul $t2, $t2, 10 # countVal = countVal * 10
	div $t0, $t0, 8 # n = n / 8
	j loop

printOctal: # print result
	li $v0, 1
	add $a0, $zero, $t1
	syscall
	j endMain

endMain:
	li $v0, 10
	syscall
