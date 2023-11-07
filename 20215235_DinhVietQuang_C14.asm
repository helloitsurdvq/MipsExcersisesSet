.data
input1: .space 256
input2: .space 256
output1: .space 256
output2: .space 256
inputup1: .space 256
inputup2: .space 256
outputlast: .space 256
space:	.asciiz " "
Message1: .asciiz "String A: "
Message2: .asciiz "String B: "
Message3: .asciiz "Uppercases in both A and B are: "
.text
main:
    	li $v0, 4
    	la $a0, Message1
    	syscall
    
    	li $v0, 8 # String A
    	la $a0, input1
    	li $a1, 256
    	syscall

    	li $v0, 4
    	la $a0, Message2
    	syscall

    	li $v0, 8 # string B
    	la $a0, input2
    	li $a1, 256
    	syscall

    	la $t0, input1
    	la $t1, input2
    	la $t6, output1
    	la $t7, output2
    	la $s6, inputup1
    	la $s7, inputup2
    	la $s5, outputlast
    	li $t5, 0
    	li $t4, ' '
    	li $s2, 0
    	li $s3, 0
    	li $t8, 1
loop1:
    	lb $t2, ($t0) # load characters from input strings
    	beqz $t2, loop2 # check for end of string
    	beq $t2, $t4, space1 # check if character is a space
    	beqz $t5, uppercase1 # while true go to uppercase1
loop2:
    	lb $t3, ($t1) # load characters from input strings
    	beqz $t3, out # check for end of string
    	beq $t3, $t4, space2 # check if character is a space
    	beqz $t5, uppercase2 # while true go to uppercase2

uppercase1:
    	blt $t2, 'a', found_uppercase1
    	bgt $t2, 'z', found_uppercase1
    	addi $t0, $t0, 1
    	j loop1	
found_uppercase1:
    	sb $t2, ($t6)
    	addi $t6, $t6, 1
    	add $s2, $s2, $t8
# go to next character in input string
    	addi $t0, $t0, 1
    	j loop1

uppercase2:
# convert to lowercase if necessary
    	blt $t3, 'a', found_uppercase2
    	bgt $t3, 'z', found_uppercase2
    	addi $t1, $t1, 1
    	j loop2
found_uppercase2:
    	sb $t3, ($t7)
    	addi $t7, $t7, 1
    	add $s3, $s3, $t8
# go to next character in input string
    	addi $t1, $t1, 1
    	j loop2

space1: # go to next character in input string
    	addi $t0, $t0, 1
    	j loop1
space2: # go to next character in input string
    	addi $t1, $t1, 1
    	j loop2
out:
    	li $v0, 4
    	la $a0, Message3
    	syscall

compare:
	sub $t6, $t6, $s2
	sub $t7, $t7, $s3 
 # load characters from input strings
    	lb $s6, ($t6)
    	lb $s7, ($t7)
    	beqz $s6, end
    	beqz $s7, end
    	beq $s6, $s7, check_case
    	addi $t7, $t7, 1
    	j compare
check_case:
	sb $s6, ($s5)
    	addi $s5, $s5, 1
	addi $t5, $t5, 1 # cnt++
	# next char in both string
	addi $s7, $s7, 1
    	addi $s6, $s6, 1
    	j compare
    	
end:   
    	li $v0, 4
    	la $a0, outputlast
    	syscall

	li $v0, 10 # exit program 
	syscall
