.data
	string_space: .space 1024         # Reserve space for input string.
	is_palin_msg: .asciiz "The string is a symmetrical.\n"
	not_palin_msg: .asciiz "The string is not a symmetrical.\n"
	string_prompt: .asciiz "Enter a string: "
.text
main:
  	la $s1, string_space # Initialize input buffer pointer.

input_loop:
  # Print the prompt:
  li $v0, 4
  la $a0, string_prompt
  syscall

  # Read the string S:
  li $v0, 8
  la $a0, string_space
  li $a1, 1024
  syscall

  # Check if the string is a palindrome:
  la $t1, string_space
  la $t2, string_space

length_loop:
    lb $t3, 0($t2)
    beqz $t3, end_length_loop
    addu $t2, $t2, 1
    b length_loop

end_length_loop:
    subu $t2, $t2, 2

test_loop:
    bge $t1, $t2, is_palin
    lb $t3, 0($t1)
    lb $t4, 0($t2)
    bne $t3, $t4, not_palin
    addu $t1, $t1, 1
    subu $t2, $t2, 1
    j test_loop

is_palin:  
      palin_msg:	
      # Print the is_palin_msg:
      li $v0, 4
      la $a0, is_palin_msg
      syscall
      move $s3,$t1
      j exit_program
      
not_palin:
    # Print the not_palin_msg and continue input loop:
    li $v0, 4
    la $a0, not_palin_msg
    syscall

exit_program:
  li $v0, 10
  syscall
