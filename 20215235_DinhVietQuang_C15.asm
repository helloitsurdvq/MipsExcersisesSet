# Print the alphanumeric characters that do not appear in both A and B
.data
	cnt1: .space 512
	cnt2: .space 512
	s1: .space 20
	s2: .space 20
	inputMessage1: .asciiz "Input string 1: "
	inputMessage2: .asciiz "Input string 2: "
	outputMessage: .asciiz "Result: "
	appearance: .asciiz "Appearance: "
	space: .asciiz " "
	newline: .asciiz "\n"
.text
# $s0, $s1: i, j of loop
init:
	li $s0, 0 
	li $t0, 20 # $t0 = Maximum size of string
	la $t1, s1 # $t1 = addr(s1[0])
	li $v0, 4
	la $a0, inputMessage1
	syscall
main1:
	add $t4, $t1, $s0 # $t4 = addr(s[i])
	li $v0, 12
	syscall
	
	sb $v0, 0($t4)
	beq $v0, '\n', end_of_string1 # Stop if '\n' is inputted
	
	la $t5, cnt1
	mul $v0, $v0, 4
	add $t5, $t5, $v0 # $t5 = addr(cnt[$v0])
	lw $t6, ($t5) # $t6 = cnt[$v0]
	addi $t6, $t6, 1
	sw $t6, ($t5)
	
	addi $s0, $s0, 1
	beq $s0, $t0, end_of_string1 # Stop if maximum size is reached
	j main1
end_of_string1:
	move $t0, $s0 # $t0: size of s1
	
	li $s0, 0 
	li $t2, 20 # $t2 = Maximum size of string
	la $t3, s2 # $t3 = addr(s2[0])
	li $v0, 4
	la $a0, inputMessage2
	syscall
main2:
	add $t4, $t3, $s0 # $t4 = addr(s[i])
	li $v0, 12
	syscall
	
	sb $v0, 0($t4)
	beq $v0, '\n', end_of_string2 # Stop if '\n' is inputted
	
	la $t5, cnt1
	mul $v0, $v0, 4
	add $t5, $t5, $v0 # $t5 = addr(cnt[$v0])
	lw $t6, ($t5) # $t6 = cnt[$v0]
	addi $t6, $t6, 1
	sw $t6, ($t5)
	
	addi $s0, $s0, 1
	beq $s0, $t2, end_of_string2 # Stop if maximum size is reached
	j main2
end_of_string2:
	move $t2, $s0 # $t2: size of s2
	
	li $v0, 4
	la $a0, outputMessage
	syscall
	
	li $s0, 48 # 48 = '0' in ascii
check_appear_loop:
	beq $s0, 58, end_main
	la $t4, cnt1
	mul $t5, $s0, 4
	add $t4, $t4, $t5
	la $t6, cnt2
	mul $t7, $s0, 4
	add $t6, $t6, $t7
	lw $t5, ($t4)
	lw $t7, ($t6)
	or $t8, $t5, $t7 # $t5, $t7 = cnt1[i], cnt2[i]. $t5, $t7 > 0 -> $t8 > 0
	bgt $t8, $zero, appear
	
	li $v0, 11
	add $a0, $s0, $zero
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
appear:
	addi $s0, $s0, 1
	j check_appear_loop

end_main:
	li $v0, 10			
	syscall
