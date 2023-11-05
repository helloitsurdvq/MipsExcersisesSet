# print the sum of digits number in binary form
.data
	prompt: .asciiz "Enter positive integer: "
	invalid: .asciiz "Invalid input\n"
	message: .asciiz "Sum of binary digits: "
.text
input:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0 #s0 = N
	
	slt $t0, $0, $s0  # 0 < N?
	beq $t0, $0, input # N <= 0 -> re input
print:	
	move $a0, $s0
	jal sumBinary
endMain:
	li $v0, 10
	syscall
	
#Function void sumBinary(int n)
sumBinary:
	move $s1, $a0       # temp = n
	li $s2, 0           # sum = 0
	li $s3, 2           # s3 = 2
loop:
	beq $s1, $0, endLoop  # temp = 0 -> end loop
	div $s1, $s3
	mflo $s1        # temp = temp/2
	mfhi $s4        # temp = temp%2
	add $s2, $s2, $s4   #update sum
	
	j loop
endLoop:
	li $v0, 4
	la $a0, message
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	jr $ra