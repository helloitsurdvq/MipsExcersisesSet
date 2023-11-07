.data
	s: .space 21
	inputMessage: .asciiz "Input string: "
	outputMessage: .asciiz "Result: "
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
	addi $s0, $s0, 1
	beq $s0, $t0, end_of_string # Stop if maximum size is reached
	j main
end_of_string:
	move $t0, $s0 # $t0: size of string
	
	# add ' ' at end
	add $t2, $t0, $t1 # $t2 = addr(s[N])
	li $t3, 32 # $t3 = ' '
	sb $t3, ($t2)
	add $t0, $t0, 1
	
	li $t2, 0 # $t2 = max length of word
	li $s2, -1 # $s2 = start id of longest word
	
	li $s0, 0
	li $t3, 0 # $t3: length counter for next loop
find_longest_loop:
	beq $s0, $t0, after_find_longest_loop
	add $t4, $t1, $s0
	lb $t5, ($t4) # $t5 = s[i]
	beq $t5, 32, if_space
	add $t3, $t3, 1
	j after_if_space_or_not

if_space:
	ble $t3, $t2, not_longer
	move $t2, $t3
	sub $s2, $s0, $t3

not_longer:
	li $t3, 0
	
after_if_space_or_not:
	add $s0, $s0, 1
	j find_longest_loop
	
after_find_longest_loop:
	li $v0, 4
	la $a0, outputMessage
	syscall

	li $s0, 0
	la $t3, s
	add $t3, $t3, $s2
print_loop:
	beq $s0, $t2, end_main
	
	li $v0, 11
	lb $a0, ($t3)
	syscall # print longest word
	
	add $t3, $t3, 1
	add $s0, $s0, 1
	j print_loop
	
end_main:
	li $v0, 10			
	syscall