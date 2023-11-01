# input N => print sum of odd and even digit in N 
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message1: .asciiz "Sum of odd digit in N: "
	message2: .asciiz "Sum of even digit in N: "
	space: .asciiz " "
	line: .asciiz "\n"
	
.text
init: 
	li $t0, 0 # init N
	li $t1, 0 # odd sum
	li $t2, 0 # even sum
main:
	li $v0, 4 
	la $a0, prompt
	syscall
	
	li $v0, 5 # input N
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	j loop
	
printInvalid:
	li $v0, 4
	la $a0, err
	syscall
	j endMain 
	
loop: 
	blez $t0, printAns
	rem $t4, $t0, 10 # digit = N % 10
	rem $s0, $t4, 2 # $s0 = digit % 2
	beqz $s0, sumEven # check if $s0 even or odd for calculation
	beq $s0, 1, sumOdd
	sumEven:
		add $t2, $t2, $t4 # calculate evenSum
		j continue
	sumOdd:
		add $t1, $t1, $t4  # calculate oddSum
		j continue
	continue: 
		div $t0, $t0, 10 # N = N / 10
		j loop

printAns:
	li $v0, 4
	la $a0, message1
	syscall
	
	li $v0, 1
	move $a0, $t1 # print oddSum
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, message2
	syscall
	
	li $v0, 1
	move $a0, $t2 #print evenSum
	syscall

endMain:
	li $v0, 10
	syscall