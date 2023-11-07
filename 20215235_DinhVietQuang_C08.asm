# Enter the character string and character C from the keyboard. Prints the number of times the character C appears in the string
.data
	s: .space 20
	inputMessage: .asciiz "Enter string: "
	inputCharMessage: .asciiz "Enter char: "
	outputMessage: .asciiz "\nResult: "
.text
# $s0, $s1: i, j of loop
init:
	li $s0, 0 
	li $t0, 20 # $t0 = Maximum size of string
	la $t1, s # $t1 = addr(s[0])
	li $v0, 4
	la $a0, inputMessage
	syscall
main:
	add $t2, $t1, $s0 # $t2 = addr(s[i])
	li $v0, 12
	syscall
	
	sb $v0, 0($t2)
	beq $v0, '\n', end_of_string # Stop if '\n' is inputted
	addi $s0, $s0, 1
	beq $s0, $t0, end_of_string # Stop if maximum size is reached
	j main
end_of_string:
	move $t0, $s0 # $t0: size of string
	li $v0, 4
	la $a0, inputCharMessage # Print message
	syscall
	
	li $v0, 12
	syscall
	
	add $t2, $v0, $zero # $t2 = char c
	addi $t6, $t2, 32 # if $t2 is upper 
	addi $t7, $t2, 32 # if $t2 is lower
	li $t3, 0 # $t3: counter
	
	li $s0, 0
count_c:
	beq $s0, $t0, end_main
	add $t4, $t1, $s0 # $t4 = addr(s[i])
	lb $t5, ($t4)
	#bne $t5, $t2, not_equal_c
	sne $s1, $t5, $t2
	sne $s2, $t5, $t6
	sne $s3, $t5, $t7
	and $s4, $s1, $s2
	and $s5, $s3, $s4
	bnez $s5, not_equal_c
	add $t3, $t3, 1
not_equal_c:
	addi $s0, $s0, 1
	j count_c

end_main:
	li $v0, 4
	la $a0, outputMessage
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 10			
	syscall