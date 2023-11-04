# input N -> print to the screen the largest power of 2 less than N

.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	res: .asciiz "Largest power of 2 less than N: "
	space: .asciiz " "
	line: .asciiz "\n"
	
.text
init: 
	li $t0, 0 # init N
	li $t1, 1 # result
	
main:
	li $v0, 4 
	la $a0, prompt
	syscall
	
	li $v0, 5 # input N
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	j loop
	
printInvalid:
	li $v0, 4
	la $a0, err
	syscall
	j endMain

loop:
	mul $t2, $t1, 2 # i*2
	bge $t2, $t0, printResult # (while i*2 < N) => i *= 2
	mul $t1, $t1, 2
	j loop
	
printResult:
	li $v0, 4
	la $a0, res
	syscall

	li $v0, 1
	move $a0, $t1
	syscall

endMain:
	li $v0, 10
	syscall