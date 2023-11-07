.data
cnt: .word 256
s:	.space 21
inputMessage: .asciiz "Input string: "
outputMessage: .asciiz "Result: "
appearance: .asciiz "Appearance: "
space: .asciiz " "
newline: .asciiz "\n"
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
	
	li $s0, 97
	li $s1, 97 # $s1 = minChar
	la $t3, cnt
	mul $v0, $s0, 4
	add $t3, $t3, $v0 # $t3 = addr(cnt['A'])
	lw $s2, ($t3) # $s2 = cnt[minChar]
	li $s0, 98
	
check_min_loop:
	beq $s0, 123, after_check_min_loop
	la $t3, cnt
	mul $v0, $s0, 4
	add $t3, $t3, $v0 # $t3 = addr(cnt[i])
	lw $t4, ($t3) # $t4 = cnt[i]
	
	beq $t4, $zero, not_change
	beq $s2, $zero, adjust_min_char
	
	bgt $t4, $s2, not_change
	
adjust_min_char:
	move $s1, $s0
	move $s2, $t4
	
not_change:
	addi $s0, $s0, 1
	j check_min_loop
	
after_check_min_loop:
	li $v0, 4
	la $a0, outputMessage
	syscall
	
	li $v0, 11
	add $a0, $s1, $zero
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, appearance
	syscall
	
	li $s0, 0
find_min_in_string:
	beq $s0, $t0, end_main
	la $t3, s
	add $t3, $t3, $s0 # $t3 = addr(s[i])
	lb $t4, ($t3) # $t4 = s[i]
	bne $t4, $s1, not_same
	
	li $v0, 1
	add $a0, $s0, $zero
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
not_same:
	addi $s0, $s0, 1
	j find_min_in_string

end_main:
	li $v0, 10			
	syscall
