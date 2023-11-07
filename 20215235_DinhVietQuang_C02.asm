.data
cnt: .word 256
s:	.space 21
inputMessage: .asciiz "Input string: "
outputMessage: .asciiz "Result: "
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
	la $t3, cnt
	mul $v0, $v0, 4
	add $t3, $t3, $v0 # $t3 = addr(cnt[$v0])
	lw $t4, ($t3) # $t4 = cnt[$v0]
	addi $t4, $t4, 1
	sw $t4, ($t3)
	addi $s0, $s0, 1
	beq $s0, $t0, end_of_string # Stop if maximum size is reached
	j main
end_of_string:
	move $t0, $s0 # $t0: size of string
	li $v0, 4
	la $a0, outputMessage # Print message
	syscall
	
	li $v0, 11
	addi $a0, $zero, 10
	syscall
	
	li $s0, 33
print_loop:
	beq $s0, 127, end_main
	la $t3, cnt
	mul $v0, $s0, 4
	add $t3, $t3, $v0 # $t3 = addr(cnt[i])
	lw $t4, ($t3) # $t4 = cnt[i]
	ble $t4, $zero, not_print
	 
	li $v0, 11
	add $a0, $s0, $zero
	syscall
	
	li $v0, 11
	addi $a0, $zero, 58
	syscall
	
	li $v0, 1
	add $a0, $t4, $zero
	syscall
	
	li $v0, 11
	addi $a0, $zero, 10
	syscall
	
not_print:
	addi $s0, $s0, 1
	j print_loop

end_main:
	li $v0, 10			
	syscall
