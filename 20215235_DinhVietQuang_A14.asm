# enter a, b, c => check the trangle and right triangle made of a, b, c
.data
	prompt1: .asciiz "Enter positive integer a: "
	prompt2: .asciiz "Enter positive integer b: "
	prompt3: .asciiz "Enter positive integer c: "
	invalid: .asciiz "Invalid input\n"
	message1: .asciiz "Not triangle"
	message2: .asciiz "Normal triangle"
	message3: .asciiz "Right triangle"
.text
input_a:
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0 #s0 = a
	
	slt $t0, $0, $s0  # 0 < a?
	beq $t0, $0, input_a # a <= 0 -> re input
input_b:
	li $v0, 4
	la $a0, prompt2
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0 #s1 = b
	
	slt $t0, $0, $s1  # 0 < b?
	beq $t0, $0, input_b # b <= 0 -> re input
input_c:
	li $v0, 4
	la $a0, prompt3
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0 #s2 = c
	
	slt $t0, $0, $s2  # 0 < c?
	beq $t0, $0, input_c # c<= 0 -> re input
main:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	jal checkTriangle
endMain:
	li $v0, 10
	syscall
	
#Function checkTriangle
checkTriangle:
	add $s3, $a0, $a1    # s3 = a + b
	slt $t0, $a2, $s3   # a+b>c?
	beq $t0, $0, notTriangle
	
	add $s3, $a0, $a2 # s3 = a+c
	slt $t0, $a1, $s3 # a+c>b?
	beq $t0, $0, notTriangle
	
	add $s3, $a1, $a2 # s3 = b+c
	slt $t0, $a0, $s3 # b+c>a?
	beq $t0, $0, notTriangle
	
	mul $s3, $a0, $a0
	mul $s4, $a1, $a1
	add $s5, $s3, $s4
	mul $s6, $a2, $a2
	beq $s6, $s5, rightTriangle
	
	mul $s3, $a2, $a2
	mul $s4, $a1, $a1
	add $s5, $s3, $s4
	mul $s6, $a0, $a0
	beq $s6, $s5, rightTriangle
	
	mul $s3, $a0, $a0
	mul $s4, $a2, $a2
	add $s5, $s3, $s4
	mul $s6, $a1, $a1
	beq $s6, $s5, rightTriangle
normalTriange:
	li $v0, 4
	la $a0, message2
	syscall
	jr $ra
rightTriangle:
	li $v0, 4
	la $a0, message3
	syscall
	jr $ra
notTriangle:
	li $v0, 4
	la $a0, message1
	syscall
	jr $ra