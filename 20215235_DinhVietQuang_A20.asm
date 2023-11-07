# Print to the screen the smallest square number greater than N
.data
	promptM: .asciiz "Enter M: "
	promptN: .asciiz "Enter N: "
	error: .asciiz "Error input."
	message: .asciiz "Output: "
.text
init:
 
	li $t0, 0 #init N
main:
	li $v0, 4 
	la $a0, promptN
	syscall
	
	li $v0, 5 # input N
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	
	li $t1, 0
loop:
	bge $t2, $t0, end_loop
	addi $t1, $t1, 1
	mul $t2, $t1, $t1
	j loop
	
end_loop:
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
