# print the number in inverted digits order
.data
	prompt: .asciiz "Enter positive integer (>10): "
	invalid: .asciiz "Invalid input\n"
	message: .asciiz "Inverted number: "
.text
input:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0 #s0 = N
	
	sub $t0, $s0, 10
	bltz $t0, input  # N < 10 -> re input
print:
	li $v0, 4
	la $a0, message
	syscall
	
	move $a0, $s0
	jal invertNumber
	
	move $a0, $v0
	li $v0, 1
	syscall #print inverted number
endMain:
	li $v0, 10
	syscall

#Function int invertNumber(int n)
invertNumber:
	move $s1, $a0    #temp = n
	li $v0, 0        #res = 0
	li $s2, 10       #s2 = 10
loop:
	beq $s1, $0, endLoop
	div $s1, $s2
	mflo $s1 #temp = temp/10
	mfhi $s3 #last digit = temp%10
	mul $v0, $v0, 10
	add $v0, $v0, $s3  #res = res*10+ last digit
	j loop
endLoop:
	jr $ra