#+++++++++++Assembly Language and Computer Architecture Lab+++++++++++
# 			Dinh Viet Quang - 20215235    		      #
# Student of ICT, SOICT, Hanoi University of Science and Technology  #
#  Task 5: Convert Infix to Postfix and calculate that expression    #
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.data
infix: .space 256
postfix: .space 256
stack: .space 256
prompt:	.asciiz "Enter infix expression \nInput must be integer and positive number: "
newLine: .asciiz "\n"
prompt_infix: .asciiz "Infix: "
prompt_postfix: .asciiz "Postfix: "
prompt_result: .asciiz "Result: "
notifi1:.asciiz "Valid expression.\n"
notifi2:.asciiz "Invalid expression.\n"
notifi3:.asciiz "Invalid character.\n"
div_by_zero_msg: .asciiz "Zero division error!\n"
unbalanced_paren_msg: .asciiz "Missing parentheses!\n"
notifi4:.asciiz "Press 1 to continue, 0 to end. Your choice? "
# get infix
.text
input:
	li $v0, 54
	la $a0, prompt
	la $a1, infix
	la $a2, 256
 	syscall 
	
	jal exception #check exception
 
	la $a0, prompt_infix
	li $v0, 4
	syscall
	
	la $a0, infix
	li $v0, 4
	syscall

# convert to postfix
	li $s6, -1 # counter, i loop
	li $s7, -1 # Scounter ... stack count
	li $t7, -1 # Pcounter... num characters in result
	
while:
        la $s1, infix #buffer = $s1, s1[]: input
        la $t5, postfix #postfix = $t5, t5[]: result
        la $t6, stack #stack = $t6[]
        li $s2, '+'
        li $s3, '-'
        li $s4, '*'
        li $s5, '/'
	addi $s6, $s6, 1 # counter++
	
# get buffer[counter]
	add $s1, $s1, $s6
	lb $t1, 0($s1) # t1 = value of buffer[counter]
	
	beq $t1, '(', pushToStack 	
	nop	
	beq $t1, ')', processing # Push until meet (
	nop
	beq $t1, $s2, operator # '+'
	nop
	beq $t1, $s3, operator # '-'
	nop
	beq $t1, $s4, operator # '*'
	nop
	beq $t1, $s5, operator # '/'
	nop
	beq $t1, 37, operator # 37-ascii for '%'
	nop				
	beq $t1, 10, n_operator # '\n'->
	nop
	beq $t1, 32, n_operator # ' '
	nop
	beq $t1, $zero, endWhile
	nop
	
#number-->Push to postfix, check number with many digits
	addi $t7, $t7, 1
	add $t5, $t5, $t7 #t5: result array..
	sb $t1, 0($t5)
	
	lb $a0, 1($s1) #assign a[0] = infix[i+1]

	jal check_number #true -> v0 = 1; false -> 0
	beq $v0, 1, n_operator
	nop
	
	add_space: #not a number -> add space
		add $t1, $zero, 32
		sb $t1, 1($t5)
		addi $t7, $t7, 1
	
	j n_operator # continue
	nop
	
processing:	
	la $t5, postfix
	la $t6, stack
	add $t6, $t6, $s7 # address of current string 
	lb $t2, 0($t6)
	beq $t2, '(', processing2 # meet '('
	nop
 	# '(' -> pop and push to postfix
	sb $zero, 0($t6)
	addi $s7, $s7, -1	  
	add $t6, $t6, -1
	#---- put in postfix
	add $t7, $t7, 1
	add $t5, $t5, $t7 
	sb $t2, 0($t5)

	j processing
	nop
	
processing2: 
	# delete '(', end for processing ')'
	sb $zero, 0($t6)
	addi $s7, $s7, -1	  
	j while
	nop
								
operator:
# add to stack if stack empty		
	beq $s7, -1, pushToStack
	nop
	
	la $t6, stack
	add $t6, $t6, $s7 #t6 = stack[], s7 = num of stack elements
	lb $t2, 0($t6) # t2 = value of stack[counter]
	beq $t2, '(', pushToStack
	nop
#t1 - check the degreee of current element, +-:1|2
	beq $t1, $s2, t1to1
	nop
	beq $t1, $s3, t1to1
	nop
	
	li $t3, 2
	
	j check_t2 # check degree of stack top
	nop
		
t1to1:
	li $t3, 1
	
check_t2: # t2 check the degree of stack top
	beq $t2, $s2, t2to1
	nop
	beq $t2, $s3, t2to1
	nop
	
	li $t4, 2	
	
	j compare_precedence # comparing degree
	nop
	
t2to1:
	li $t4, 1	
	
compare_precedence:
	slt $s1, $t4, $t3
	bnez $s1, t3_large_t4
	nop
	
# t4>=t3
# pop t2 from stack  and t2 ==> postfix  
# get new top stack and do again
# assign top of stack = 0 , decrease sl -1, reduce address by 1
	la $t6, stack
	add $t6, $t6, $s7
	sb $zero, 0($t6)
	addi $s7, $s7, -1 # scounter ++
# put stack top to the result array
	la $t5, postfix # postfix = $t5
	addi $t7, $t7, 1
	add $t5, $t5, $t7
	sb $t2, 0($t5)
	
	j operator
	nop	
t3_large_t4:
# push t1 to stack
	j pushToStack
	nop
	
pushToStack:
	la $t6, stack #stack = $t6
	addi $s7, $s7, 1 # scounter ++
	add $t6, $t6, $s7
	sb $t1, 0($t6)	
	
n_operator:	
	j while	
	nop
	
endWhile:
	addi $s1, $zero, 32
	add $t7, $t7, 1
	add $t5, $t5, $t7 
	la $t6, stack
	add $t6, $t6, $s7
	
popallstack:
	lb $t2, 0($t6) # t2 = value of stack[counter]
	beq $t2, 0, endPostfix
	sb $zero, 0($t6)
	addi $t6, $t6, -1
	sb $t2, 0($t5)
	add $t5, $t5, 1
	j popallstack
	nop

endPostfix: # the end of postfix
# print postfix
	la $a0, prompt_postfix
	li $v0, 4
	syscall

	la $a0, postfix
	li $v0, 4
	syscall

	la $a0, newLine
	li $v0, 4
	syscall

## Calculate
li $s3, 0 # counter
la $s2, stack #stack = $s2
# postfix to stack
while_p_s:
	la $s1, postfix #postfix = $s1
	
	add $s1, $s1, $s3
	lb $t1, 0($s1) #t1= posfix[i]
	
	beqz $t1 end_while_p_s # end of string
	nop
	
	add $a0, $zero, $t1
	jal check_number #number vo->1, operator vo->0
	nop
	
	beqz $v0, is_operator #Pop stack and calculate
	nop
	
	jal add_number_to_stack
	nop
	
	j continue
	nop
	
is_operator:
	jal pop
	nop
	
	add $a1, $zero, $v0 # b
	jal pop
	nop
	
	add $a0, $zero, $v0 # a
	add $a2, $zero, $t1 # op
	jal calculate
		
continue:
	add $s3, $s3, 1 # counter++
	j while_p_s
	nop

#-----------------------------------------------------------------
#Procedure calculate
# @brief calculate the number ("a op b")
# @param[int] a0 : (int) a
# @param[int] a1 : (int) b
# @param[int] a2 : operator(op) as character
#-----------------------------------------------------------------
calculate:
	sw $ra, 0($sp) # save addr line 266
	li $v0, 0
	beq $t1, '%', cal_case_mod
	nop
	beq $t1, '*', cal_case_mul
	nop
	beq $t1, '/', cal_case_div
	nop
	beq $t1, '+', cal_case_add
	nop
	beq $t1, '-', cal_case_sub
	
	cal_case_add: # a+b -> push result to stack	
		add $v0, $a0, $a1
		j cal_push
	cal_case_sub: # a-b
		sub $v0, $a0, $a1
		j cal_push
	cal_case_mul: # a*b 
		mul $v0, $a0, $a1
		j cal_push
	cal_case_div: # a/b
		div $a0, $a1
		mflo $v0
		j cal_push
	cal_case_mod: # a%b
		div $a0, $a1
		mfhi $v0
		j cal_push
	cal_push:
		add $a0, $v0, $zero
		jal push
		nop
		lw $ra, 0($sp) # get address line 266 
		jr $ra
		nop
	
#-----------------------------------------------------------------
#Procedure add_number_to_stack
# @brief get the number and add number to stack at $s2
# @param[in] s3 : counter for postfix string
# @param[in] s1 : postfix string
# @param[in] t1 : current value
#-----------------------------------------------------------------
add_number_to_stack: #check so co nhiu cs
	# save $ra
	sw $ra, 0($sp) #ra = adr line 250
	li $v0, 0
	
	while_ants:
		beq $t1, '0', ants_case_0
		nop
		beq $t1, '1', ants_case_1
		nop
		beq $t1, '2', ants_case_2
		nop
		beq $t1, '3', ants_case_3
		nop
		beq $t1, '4', ants_case_4
		nop
		beq $t1, '5', ants_case_5
		nop
		beq $t1, '6', ants_case_6
		nop
		beq $t1, '7', ants_case_7
		nop
		beq $t1, '8', ants_case_8
		nop
		beq $t1, '9', ants_case_9
		nop
		
		ants_case_0:
			j ants_end_sw_c
		ants_case_1:
			addi $v0, $v0, 1	
			j ants_end_sw_c
			nop
		ants_case_2:
			addi $v0, $v0, 2
			j ants_end_sw_c
			nop
		ants_case_3:
			addi $v0, $v0, 3
			j ants_end_sw_c
			nop
		ants_case_4:
			addi $v0, $v0, 4
			j ants_end_sw_c
			nop
		ants_case_5:
			addi $v0, $v0, 5
			j ants_end_sw_c
			nop
		ants_case_6:
			addi $v0, $v0, 6
			j ants_end_sw_c
			nop
		ants_case_7:
			addi $v0, $v0, 7
			j ants_end_sw_c
			nop
		ants_case_8:
			addi $v0, $v0, 8
			j ants_end_sw_c
			nop
		ants_case_9:
			addi $v0, $v0, 9
			j ants_end_sw_c
			nop
		ants_end_sw_c: # check next character, $t1
			add $s3, $s3, 1 # counter++
			la $s1, postfix #postfix = $s1
	
			add $s1, $s1, $s3
			lb $t1, 0($s1)
		
			beq $t1, $zero, end_while_ants
			beq $t1, ' ', end_while_ants
			
			mul $v0, $v0, 10
			
			j while_ants
			
	end_while_ants:
		add $a0, $zero, $v0
		jal push
	# get $ra, back to line 250
		lw $ra, 0($sp) 
		jr $ra
		nop
			
#-----------------------------------------------------------------
#Procedure check_number
# @brief check character is number or not 
# @param[int] a0 : character to check
# @param[out] v0 : 1 = true; 0 = false
#-----------------------------------------------------------------
check_number:
        
	li $t8, '0'
	li $t9, '9'
	
	beq $t8, $a0, check_number_true
	beq $t9, $a0, check_number_true
	
	slt $v0, $t8, $a0
	beqz $v0, check_number_false
	
	slt $v0, $a0, $t9
	beqz $v0, check_number_false
	
	
	check_number_true:
		li $v0, 1
		jr $ra
		nop
	check_number_false:
		li $v0, 0
		jr $ra
		nop

#-----------------------------------------------------------------
#Procedure pop
# @brief pop from stack at $s2
# @param[out] v0 : value to popped
#-----------------------------------------------------------------
pop:
	lw $v0, -4($s2)
	sw $zero, -4($s2)
	add $s2, $s2, -4
	jr $ra
	nop

#-----------------------------------------------------------------
#Procedure push
# @brief push to stack at $s2
# @param[in] a0 : value to push
#-----------------------------------------------------------------
push:
	sw $a0, 0($s2)
	add $s2, $s2, 4
	jr $ra
	nop

end_while_p_s: # print postfix
	la $a0, prompt_result
	li $v0, 4
	syscall

	jal pop
	add $a0, $zero, $v0 
	li $v0, 1
	syscall

	la $a0, newLine
	li $v0, 4
	syscall
	# continue or not?
	li $v0, 4
    	la $a0, notifi4
    	syscall
    	
    	li $v0, 5
    	syscall
    	beqz $v0,finish 
    	j input

exception:
# Initialize variables
    	li $t0, 0 # Current character index
    	li $t2, 0 # Parenthesis count
# Expression - .... -> invalid
    	lb $t3, infix($t0) # ascii for character
    	beq $t3,'-',invalid_char # first negative, true -> invalid
    
eval_loop: # Get current character
    	lb $t3, infix($t0)

# Check for end of expression 'abcd', 
    	beqz $t3, predone # end string temporarily... check ()
#check negative
    	beq $t3,'-',check_nega # first negative, true -> invalid, 5*-
# Check for space or tab character
    	beq $t3, 32, skip_char # " "
    	beq $t3, 9, skip_char #tab
    	beq $t3, 10, skip_char #\n
# Check for integer digit
    	blt $t3, 48, check_op #<0
    	bgt $t3, 57, check_op #>0

    	j next_char # Integer digit found, move to next character
    
check_op:
# Check for operator character
    	beq $t3, 40, inc_paren # (
    	beq $t3, 41, dec_paren # )
    	beq $t3, 43, next_char # +
    	beq $t3, 45, next_char # -
    	beq $t3, 42, next_char # *
    	beq $t3, 47, next_char1 # /
    	beq $t3, 37, next_char1 # %
    
    	la $a0, notifi3 # invalid
    	li $v0, 4
    	syscall
    	
    	j invalid_char

inc_paren:
    	addi $t2, $t2, 1
    	j next_char
dec_paren:
    	sub $t2, $t2, 1
    	bltz $t2, invalid_char
    	j next_char
predone:
	beqz $t2, done # done -> continue
	la $a0, unbalanced_paren_msg # parentheses error
	li $v0, 4
	syscall
	j invalid_char
done:
	la $a0, notifi1 # invalid
	li $v0, 4
	syscall
	
	jr $ra
invalid_char: # Invalid character found, print input
	la $a0, prompt_infix
	li $v0, 4
	syscall
	
	la $a0, infix
	li $v0, 4
	syscall
	
    	li $v0, 4
    	la $a0, notifi2
    	syscall
	# continue or not
    	li $v0, 4
    	la $a0, notifi4
    	syscall
    	
    	li $v0, 5
    	syscall
    	beqz $v0,finish 
    	j input

skip_char: # Move to next character
    	j next_char
next_char1:
    	add $t1, $t0, 1
    	lb $t3, infix($t1)
    
    	beq $t3, '-', invalid_char # Negative ->invalid
    	bne $t3, 48, next_char #4 8ascii -> 0: #0.. valis -> next char, not invalid div 0
    
    	li $v0, 4
    	la $a0, div_by_zero_msg
    	syscall
    	
    	j invalid_char
check_nega:
    	add $t1,$t0,-1
    	lb $t3,infix($t1)
    	beq $t3, 40, invalid_char # (
    	beq $t3, 43, invalid_char # +
    	beq $t3, 45, invalid_char # -
    	beq $t3, 42, invalid_char # *
    	beq $t3, 47, invalid_char # /
    	beq $t3, 37, invalid_char # % 
#auto next character      
next_char: # Move to next character and reset current integer
    	addi $t0, $t0, 1
    	j eval_loop
    	
finish:
