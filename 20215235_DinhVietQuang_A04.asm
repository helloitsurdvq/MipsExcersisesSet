#input N, write a function to check and print all the perfect numbers < N
.data
	prompt: .asciiz "Enter a positive integer N: "
	err: .asciiz "Invalid input!\n"
	message: .asciiz "Perfect numbers less than N: "
	space: .asciiz " "
.text
init: 
	li $t0, 0 # init N
	li $t1, 2 # i = 1
	li $t3, 1 # for checking branch
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	add $t0, $zero, $v0
	
	ble $t0, $zero, printInvalid
	
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
	bge $t1, $t0, endMain # for (int i = 2; i < N; i++)
	move $t2, $t1
	li $t3, 1
	li $t5, 0
	checkPerfect: # function Check Perfect
		bge $t3, $t2, truePerfect # for ($t3 = 1; $t3 < $t2; i++)
		rem $t4, $t2, $t3
		beqz $t4, addSum # check the division
		addi $t3, $t3, 1
		j checkPerfect
		addSum:
			add $t5, $t5, $t3 #  sum = sum + $t3;
			addi $t3, $t3, 1
			j checkPerfect
	truePerfect:
		beq $t5, $t2, ok # if sum == $t1 then print, else continue
		addi $t1, $t1, 1
		j loop
		ok: 
			li $v0, 1
			move $a0, $t1
			syscall 
			
			li $v0, 4
			la $a0, space
			syscall
			
			addi $t1, $t1, 1
			j loop
		
endMain:
	li $v0, 10
	syscall