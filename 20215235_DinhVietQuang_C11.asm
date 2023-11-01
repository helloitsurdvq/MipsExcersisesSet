# print the reversed input string
.data
	string: .space 100
	message1: .asciiz "Enter string: "
	message2: .asciiz "Result: " 
	res: .asciiz ".....: "
	ms: .asciiz " "
	line: .asciiz "\n"
.text
init: 
	la $a0, string # $a0 = address(string[0])
	li $t0, 0 # $t0 = i = 0
	li $s0, 99 # Maximum size of string
	
	li $v0, 4
	la $a0, message1
	syscall
read:
	add $t1, $a0, $t0 # $t1 = $a0 + $t0 = address(string[i])
	li $v0, 12 # read character
	syscall
	sb $v0, 0($t1)
	beq $v0, '\n', end_of_string # Stop if '\n' is inputted
	addi $t0, $t0, 1
	beq $t0, $s0, end_of_string # Stop if maximum size is reached
	j read
end_of_string:
	add $s1, $zero, $a0 # Move address of string to $s1 # $a0 will be used later on
	
	li $v0, 4
	la $a0, message2
	syscall
reverse_string:
	subi $t0, $t0, 1
	bltz $t0, endMain
	add $t1, $s1, $t0 # $t1 = $s1 + $t0 = address(string[i])
	li $v0, 11
	lb $a0, 0($t1) # Load string[i]
	syscall # Print string[i]
	j reverse_string
endMain:
	li $v0, 10 #exit
 	syscall
