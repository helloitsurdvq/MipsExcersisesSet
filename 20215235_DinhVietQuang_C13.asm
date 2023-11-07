.data
	strA: .space 300
	strB: .space 300
	lowercaseInA: .space 104 #int lowercaseInA[26]
	lowercaseInB: .space 104 #int lowercaseInB[26]
	message1: .asciiz "Enter string A: "
	message2: .asciiz "Enter string B: "
	res: .asciiz "Lowercase chars in A but not in B: "
.text
main:
input:
	li $v0, 4
	la $a0, message1
	syscall
	
	li $v0, 8
	la $a0, strA
	li $a1, 300
	syscall
	
	li $v0, 4
	la $a0, message2
	syscall
	
	li $v0, 8
	la $a0, strB
	li $a1, 300
	syscall
end_input:
	la $s1, strA #s1: pointer to strA
	la $s3, lowercaseInA
count_lower_A:
	lb $s2, 0($s1) #s2: strA[i]
	beq $s2, 10, end_count_A
	beq $s2, $0, end_count_A
	
	sub $t0, $s2, 97 
	bltz $t0, continue_A  #strA[i] < 'a'
	sub $t0, $s2, 122
	bgtz $t0, continue_A #strA[i] > 'z'
	
	sub $t0, $s2, 97 #t0 = strA[i] - 'a'
	add $t0, $t0, $t0
	add $t0, $t0, $t0
	add $t0, $t0, $s3 #t0: address of lowercaseInA[strA[i]-'a']
	li $t1, 1
	sw $t1, 0($t0)  #lowercaseInA[strA[i]-'a'] = 1
continue_A:
	addi $s1, $s1, 1
	j count_lower_A
end_count_A:
	la $s1, strB #s1: pointer to strB
	la $s3, lowercaseInB
count_lower_B:
	lb $s2, 0($s1) #s2: strB[i]
	beq $s2, 10, end_count_B
	beq $s2, $0, end_count_B
	
	sub $t0, $s2, 97 
	bltz $t0, continue_B  #strB[i] < 'a'
	sub $t0, $s2, 122
	bgtz $t0, continue_B #strB[i] > 'z'
	
	sub $t0, $s2, 97 #t0 = strB[i] - 'a'
	add $t0, $t0, $t0
	add $t0, $t0, $t0
	add $t0, $t0, $s3 #t0: address of lowercaseInB[strB[i]-'a']
	li $t1, 1
	sw $t1, 0($t0)  #lowercaseInB[strB[i]-'a'] = 1
continue_B:
	addi $s1, $s1, 1
	j count_lower_B
end_count_B:
	li $v0, 4
	la $a0, res
	syscall
	
	li $s0, 0 #i=0
	la $s1, lowercaseInA
	la $s2, lowercaseInB
loop:
	beq $s0, 26, end_main
	
	lb $s3, 0($s1) #lowercaseInA[i]
	lb $s4, 0($s2) #lowercaseInB[i]
	
	beq $s3, $0, continue #lowercaseInA[i] = 0
	beq $s4, 1, continue #lowercaseInB[i] = 1
	
	addi $s5, $s0, 97  #s5 = 'a' + i
	li $v0, 11
	move $a0, $s5
	syscall
continue:
	addi $s0, $s0, 1
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	j loop
end_main:
	li $v0, 10
	syscall