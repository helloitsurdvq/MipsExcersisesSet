# Find and print the smallest integer that is a divisor of M and greater than N
.data
	prompt_m: .asciiz "Enter M: "
    	prompt_n: .asciiz "Enter N: "
    	result: .asciiz " is the result"

.text
.globl main

main:
    	li $v0, 4
    	la $a0, prompt_m
    	syscall

    	li $v0, 5
    	syscall
    	move $t0, $v0  

    	li $v0, 4
    	la $a0, prompt_n
    	syscall

   	li $v0, 5
    	syscall
    	move $t1, $v0  # $t5 = n

    	move $a0, $t0
    	move $a1, $t1
    	jal findSmallestDivisor

    	move $a0, $v0 # Print result
    	li $v0, 1
    	syscall
    	
    	li $v0, 4
    	la $a0, result
    	syscall

    	li $v0, 10
    	syscall

# function to find the divisor of M
# Input: $a0 = M, $a1 = N
# Ouput: $v0 
findSmallestDivisor:
    	move $t2, $a1 
    	div $s0, $a0, 2 # M/2

    	loop:
        	addi $t2, $t2, 1  # divisor += 1
        	slt $t1, $s0, $t2 # If t2 > s0,exit loop s0 < t2
        	bnez $t1, no_divisor  # If > M/2 => end Loop

        	div $a0, $t2  # M /= div
        	mfhi $t3  # rem = $t3
        	beq $t3, $zero, found_divisor  # rem = 0 => found
        	j loop  

    	found_divisor:
        	move $v0, $t2  # store div into $v0
        	jr $ra

    	no_divisor:
        	li $v0, -1  # not found, return -1
        	jr $ra
