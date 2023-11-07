# Enter two strings s1 and s2, check if string s2 is a substring of s1 or not
.data
	cnt: .space 1024
	s1: .space 20
	s2: .space 20
	s3: .space 20
	inputMessage1: .asciiz "Input string 1: "
	inputMessage2: .asciiz "Input string 2: "
	outputMessage: .asciiz "Result:"
	yes: .asciiz "Yes"
	no: .asciiz "No"
	space: .asciiz " "
	newline: .asciiz "\n"
.text
# $s0, $s1: i, j of loop
init:
	li $s0, 0 
	li $t0, 20 # $t0 = Maximum size of string
	la $t1, s1 # $t1 = addr(s1[0])
	li $t2, 20 
	la $t3, s2 # $t3 = addr(s2[0])
	li $s3, 0 # $s3: flag to check if the result is yes/no, $s3 = 1 -> yes 
	li $v0, 4
	la $a0, inputMessage1
	syscall
main1:
	add $t4, $t1, $s0 # $t4 = addr(s1[i])
	li $v0, 12
	syscall
	
	sb $v0, 0($t4)
	beq $v0, '\n', end_of_string1 # Stop if '\n' is inputted
	addi $s0, $s0, 1
	beq $s0, $t0, end_of_string1 # Stop if maximum size is reached
	j main1
end_of_string1:
	move $t0, $s0 # $t0: size of s1
	
	li $v0, 4
	la $a0, inputMessage2
	syscall
	
	li $s0, 0
main2:
	add $t4, $t3, $s0 # $t4 = addr(s[i])
	li $v0, 12
	syscall
	
	sb $v0, 0($t4)
	beq $v0, '\n', end_of_string2 # Stop if '\n' is inputted
	addi $s0, $s0, 1
	beq $s0, $t2, end_of_string2 # Stop if maximum size is reached
	j main2
end_of_string2:
	move $t2, $s0 # $t2: size of s2
	
	add $s0, $zero, $zero
	sub $s2, $t0, $t2
	addi $s2, $s2, 1 # $s2 = N1-N2+1: num of substring with length = s2
	ble $s2, $zero, endMain 
loop:
	beq $s0, $s2, endMain
	jal inits3
	jal compareString
	add $s0, $s0, 1	# i++
	j loop
	
inits3: # create s1[i ... (i+N2-1)]
	add $s1, $zero, $zero
	la $t1, s1
	add $t1, $t1, $s0 # $t1 now = addr(s1[i])
	la $t4, s3 # $t4 = addr(s3[0])
	
init_loop:
	beq $s1, $t2, after_init_loop
	lb $t5, ($t1)
	sb $t5, ($t4)
	addi $t1, $t1, 1
	addi $t4, $t4, 1
	addi $s1, $s1, 1
	j init_loop
	
after_init_loop:
	jr $ra
	
compareString:
	la $t3, s2
	la $t4, s3
	li $t5, 1 # flag
	
	li $s1, 0
compare_loop:
	beq $s1, $t2, after_compare_loop
	lb $t6, ($t3)
	lb $t7, ($t4)
	beq $t6, $t7, equal
	li $t5, 0
equal:
	add $t3, $t3, 1
	add $t4, $t4, 1
	add $s1, $s1, 1
	j compare_loop

after_compare_loop:
	beq $t5, 0, no_res
	li $s3, 1
no_res:
	jr $ra

endMain:	
	li $v0, 4
	la $a0, outputMessage
	syscall
	
	beq $s3, 1, yes_result
	
	li $v0, 4
	la $a0, no
	syscall
	
	j after_print_result
yes_result:
	li $v0, 4
	la $a0, yes
	syscall
	
after_print_result:
	li $v0, 10			
	syscall
