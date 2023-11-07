.data
	cnt: .space 512
	s: .space 30
	inputMessage: .asciiz "Input string: "
	outputMessage: .asciiz "\nResult: "
	space: .asciiz " "
	newline: .asciiz "\n"
.text
# $s0, $s1: i, j of loop
init:
	li $s0, 0 
	li $t0, 29 # $t0 = Maximum size of string
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
	
	lb $t2, ($t1)
	jal to_be_upper 
	sb $t2, ($t1) # first char to be upper
	
	li $s0, 1
convert_loop:
	beq $s0, $t0, end_main
	add $t5, $t1, $s0
	lb $t2, ($t5)
	lb $t6, -1($t5) # $t6 = s[i-1]
	beq $t6, 32, is_space
	jal to_be_lower
	j after_check_space
	
is_space:
	jal to_be_upper
	
after_check_space:
	sb $t2, ($t5)
	add $s0, $s0, 1
	j convert_loop

end_main:
	li $v0, 4
	la $a0, outputMessage
	syscall	
	
	li $v0, 4
	la $a0, s
	syscall	
	
	li $v0, 10			
	syscall

# input: $t2, output: $t2. Function use $t3, $t4
to_be_lower:
	sgtu $t3, $t2, 64
	slti $t4, $t2, 91
	and $t3, $t3, $t4
	ble $t3, $zero, is_lower
	add $t2, $t2, 32
is_lower:
	jr $ra
	
# input: $t2, output: $t2
to_be_upper:
	sgtu $t3, $t2, 96
	slti $t4, $t2, 123
	and $t3, $t3, $t4
	ble $t3, $zero, is_upper
	add $t2, $t2, -32
is_upper:
	jr $ra