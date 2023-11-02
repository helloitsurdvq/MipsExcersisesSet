# check the similarity of 2 strings
.data
	Str1: .space 256
	Str2: .space 256
	Message1: .asciiz "Enter s1 (Max 256): "
	Message2: .asciiz "Enter s2 (Max 256): "
	Message3: .asciiz "Same!"
	Message4: .asciiz "Different!"

.text
init:		
	li $s0, 0 # i = 0
	li $s1, 255 # n = 255
	la $s2, Str1 # address(Str1[0])
 	la $s3, Str2 # address(Str2[0])
	la $s4, Str1 # address(Str1[i])
 	la $s5, Str2 # address(Str2[i])
	li $s6, -1 # Str1[i]
	li $s7, -1 # Str2[i]
main:		
	li $v0, 4 # print string
	la $a0, Message1
	syscall
	
	li $v0, 8
	la $a0, Str1 # input string
	li $a1, 255
	syscall
	
	li $v0, 4 # print string
	la $a0, Message2
	syscall
	
	li $v0, 8
	la $a0, Str2 # input string
	li $a1, 255
	syscall
loop:		
	beq $s0, $s1, same # exit if i == n
	add $s4, $s2, $s0 # address(Str1[i])
	add $s5, $s3, $s0 # address(Str2[i])
	lb $s6, ($s4) # Str1[i]
	lb $s7, ($s5) # Str2[i]
		
	add $t0, $s6, $s7 # reached both ends if $t0 = 0
	beq $t0, 00, same # "\0", "\0"
	add $t0, $s6, $s7 # reached both ends if $t0 = 10
	beq $t0, 10, same # "\0", "\n" OR "\n", "\0"
	add $t0, $s6, $s7 # reached both ends if $t0 = 20
	beq $t0, 20, same # "\n", "\n"	
	bge $s6, 97, lower1 # lower(Str1[i])
	
afterLower1:	
	bge $s7, 97, lower2 # lower(Str2[i])
afterLower2:	
	bne $s6, $s7, diff # diff found if Str1[i] != Str2[i]
loopCon:		
	add $s0, $s0, 1	# i++
	j loop
lower1:		
	sub $s6, $s6, 32
	j afterLower1
lower2:		
	sub $s7, $s7, 32
	j afterLower2

same:		
	li $v0, 4 # print string
	la $a0, Message3
	syscall
	j endMain
diff:	li $v0, 4 # print string
	la $a0, Message4
	syscall
	j endMain
	
endMain:
