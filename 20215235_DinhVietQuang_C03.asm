# print the substring with shortest length in a string
.data
    	str: .space 1024     
    	min_word: .space 1024 
    	space: .asciiz " "
    	input_msg: .asciiz "Enter string: "
    	output_msg: .asciiz "Substring with shortest length: "

.text
    # Hàm main
main:
    # Print the prompt:
  	li $v0, 4
  	la $a0, input_msg
  	syscall

  	# Read the string S
  	li $v0, 8
  	la $a0, str
  	li $a1, 1024
  	syscall

# Tìm từ có độ dài ngắn nhất
    	la $t0, str          # Địa chỉ bắt đầu chuỗi
    	la $t1, min_word     # Địa chỉ lưu trữ từ có độ dài ngắn nhất
    	addi $t2, $zero, 100 # Độ dài ngắn nhất ban đầu
    
calculate_length:
	addi $s0,$zero,0
	move $s1,$t0
loop:
    	lb $t3, ($t0)        # Đọc ký tự
    	beqz $t3, end_loop   # Nếu gặp ký tự rỗng, thoát khỏi vòng lặp

    	beq $t3, 32, check # Nếu gặp dấu cách, chuyển sang từ tiếp theo

    	addi $s0, $s0, 1     # tăng độ dài từ hiện tại đi 1
    	addi $t0, $t0, 1      # Tăng địa chỉ lưu trữ chuỗi lên 1 byte
    	j loop

check:
    	blt $s0,$t2, update_min  # Nếu độ dài từ hiện tại <= độ dài từ có độ dài ngắn nhất, cập nhật từ ngắn nhất
next_word:
    	addi $t0, $t0, 1      # Tăng địa chỉ lưu trữ chuỗi lên 1 byte
    	j calculate_length

update_min:
    	la $t1, min_word     # Địa chỉ lưu trữ từ ngắn nhất
    	move $t4, $s1        # Sao chép địa chỉ từ hiện tại sang $t4

    	copy_word:
        	lb $t5, ($t4)    # Đọc ký tự
        	sb $t5, ($t1)    # Lưu ký tự vào từ ngắn nhất

        	beqz $t5, end_copy  # Nếu gặp ký tự rỗng, kết thúc sao chép
		beq $t5,32, end_copy  # Nếu gặp dau cach, kết thúc sao chép
		
        	addi $t4, $t4, 1  # Tăng địa chỉ lên 1 byte
        	addi $t1, $t1, 1  # Tăng địa chỉ lưu trữ từ ngắn nhất lên 1 byte
	
        	j copy_word
		end_copy:
			move $t2,$s0
			addi $t0, $t0, 1 # address++
    	j calculate_length
end_loop:
        # In chuỗi
print_string:
    	la $a0, output_msg 
    	li $v0, 4
    	syscall

    	la $a0, min_word # print result
    	li $v0, 4
    	syscall

    	li $v0, 10
    	syscall