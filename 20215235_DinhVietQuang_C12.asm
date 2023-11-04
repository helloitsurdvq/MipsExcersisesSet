# change all uppercase letters to lowercase and vice versa in a given string
.data
string:	.space 21
message: .asciiz "Result: "
.text
init:
	add $t0, $zero, $zero # $t0 = i = 0
	li $s0, 20 # Maximum size of string
	li $t1, 0 # i = 0
	la $t2, string
main:
	add $t3, $t2, $t0 # $t1 = $a0 + $t0 = address(string[i])
	li $v0, 12
	syscall
	
	sb $v0, 0($t3)
	beq $v0, '\n', end_of_string # Stop if '\n' is inputted
	addi $t0, $t0, 1
	beq $t0, $s0, end_of_string # Stop if maximum size is reached
	j main
end_of_string:
	#add $s1, $zero, $a0 # Move address of string to $s1 # $a0 will be used in loop branch
	li $v0, 4
	la $a0, message # Print message
	syscall	
	
loop:
	beq $t1, $t0, endMain # exit if i == n
	add $s4, $t2, $t1 # address(Str1[i])
	lb $s6, ($s4) # Str1[i] 
	sge $t4, $s6, 65
	sle $t5, $s6, 90
	and $t6, $t4, $t5 # check upper range
	bnez $t6, upper
	sge $t4, $s6, 97
	sle $t5, $s6, 122
	and $t6, $t4, $t5 
	bnez $t6, lower  # check lower range
	
	keepSpecialChar:
		j loopCon	
	loopCon:		
		add $t1, $t1, 1	# i++
		li $v0, 11
		move $a0, $s6
		syscall
		j loop

	lower:		
		sub $s6, $s6, 32
		sb $s6, ($s4)
		j loopCon
	upper:		
		add $s6, $s6, 32
		sb $s6, ($s4)
		j loopCon

endMain:
	li $v0, 10			
	syscall
