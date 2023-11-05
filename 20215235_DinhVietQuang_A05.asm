# Check is a number is lucky number or not
.data
	prompt: .asciiz "Enter positive integer: "
	invalid: .asciiz "Invalid input\n"
	message1: .asciiz " is lucky number"
	message2: .asciiz " is not lucky number"
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
printResult:
	li $v0, 1
	move $a0, $s0
	syscall

	jal checkLucky
endMain:
	li $v0, 10
	syscall
	
#Function int checkLucky(int n)
# $a0 = n, output = message1 or message2

checkLucky:
	move $s1, $a0 #s1: temp = n
	li $s2, 0 #s2: numDigits = 0
	li $s3, 0 #s3: sum = 0
	li $s4, 0 #s4: sumRight = 0
	li $s5, 10 #s5 = 10
loopCountNumDigits:
	beq $s1, $0, endLoopCountNumDigits
	addi $s2, $s2, 1 #numDigits ++
	
	div $s1, $s5
	mflo $s1 # s1 = s1/10
	mfhi $s6 # s6 = s1%10
	add $s3, $s3, $s6  # sum += last digit
	
	j loopCountNumDigits
endLoopCountNumDigits:
move $s1, $a0 # temp = n
div $s7, $s2, 2 # i = numDigits / 2
loopSumRight:
	beq $s7, $0, endLoopSumRight
	div $s1, $s5
	mflo $s1
	mfhi $s6
	add $s4, $s4, $s6 #sumRight += last digit
	
	addi $s7, $s7, -1 #i--
	j loopSumRight
endLoopSumRight:
	li $t1, 2
	div $s2, $t1    
	mfhi $t1 #t1 = numDigits%2
	beq $t1, $0, even
odd:	
	div $s1, $s5  
	mfhi $s6 #s6 = middle digit
	add $s4, $s4, $s4
	add $s4, $s4, $s6 # s4 = 2*sumRight + middle digit
	beq $s4, $s3, isLucky # sum = 2*sumRight + middle digit -> lucky
	j isNotLucky
even: 
	add $s4, $s4, $s4
	beq $s4, $s3, isLucky # sum = 2*sumRight -> lucky
	j isNotLucky
isLucky:
	li $v0, 4
	la $a0, message1
	syscall
	jr $ra
isNotLucky:
	li $v0, 4
	la $a0, message2
	syscall
	jr $ra