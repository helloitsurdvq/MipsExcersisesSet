# input positive N, print all the 3, 5- divisible nunmber < N
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message: .asciiz "Numbers divisible by 3 or 5 less than N: "
	space: .asciiz " "
.text
init: 
	li $t0, 0 # init N
main:	
	li $v0, 4
    	la $a0, prompt
    	syscall

    	li $v0, 5
    	syscall
    	add $t0, $zero, $v0  # Store N in $t0
    	
	ble $t0, $zero, printInvalid
    	li $t1, 1 # i = 1

    	li $v0, 4
    	la $a0, message
    	syscall
    	j loop

printInvalid:
	li $v0, 4
	la $a0, err
	syscall
	j endMain

loop:
    	bge $t1, $t0, endMain # Check i < N

    	# Check if i is divisible by 3 or 5
    	rem $t2, $t1, 3
    	rem $t4, $t1, 5

    	beqz $t2, print
    	beqz $t4, print

    	j continue

print:
    	# print i
    	li $v0, 1 
    	move $a0, $t1
    	syscall
    	
    	li $v0, 4
    	la $a0, space
    	syscall

continue:
    	addi $t1, $t1, 1 # increase i
    	j loop

endMain:
    	li $v0, 10
    	syscall
