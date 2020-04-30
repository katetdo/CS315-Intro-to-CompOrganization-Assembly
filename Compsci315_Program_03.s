###########################################################
#		Program Description
#	
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array size
#	$t2 sum odd values
#	$t3 user n
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9 reverse array
###########################################################
		.data
new_line_p: 		.asciiz		"\n"
sum_odd_values_p: 	.asciiz		"Sum of odd values: "
user_nth_p:			.asciiz		"Please enter a value n: "
###########################################################
		.text
main:
										# FOR CREATE, AND PRINT ARRAY
	jal create_array					# call create_array
	jal print_array  					# call print_array

	lw $t0, 4($sp)						# load array base address into t0
	lw $t1, 0($sp)						# load array size into t1
	lw $ra, 8($sp)						# restore ra 
	addi $sp, $sp, 8					# deallocate space from system stack

	li $v0, 4							# print new line
	la $a0, new_line_p
	syscall								#
######################################### FOR SUM ODD
	addi $sp, $sp, -12					# space for ra, size, address, and output value
	sw $ra, 12($sp)						# store return address
	sw $t0, 8($sp)						# store address
	sw $t1, 4($sp)						# store size 

	jal sum_odd_values					# call sum odd values

	lw $t2, 0($sp)						# load sum odd values into t2
	lw $t1, 4($sp)						# load size into t1
	lw $t0, 8($sp)						# load address
	lw $ra, 12($sp)						# load return address

	li $v0, 4							# print string 
	la $a0, sum_odd_values_p			# print "Sum odd values:"
	syscall

	li $v0, 1							# print integer
	move $a0, $t2						# print sum odd values
	syscall 

	li $v0, 4							# print new line
	la $a0, new_line_p
	syscall								#
######################################### FOR REVERSE ARRAY
	addi $sp, $sp, -12					# space for ra, address and size, 
	sw $t1, 4($sp)						# store size 
	sw $t0, 8($sp)						# store address
	sw $ra, 12($sp)						# store return address

	jal reverse_array 					# call reverse array 

	lw $ra, 12($sp)						# load return address
	lw $t0, 8($sp)						# load address
	lw $t1, 4($sp)						# load size 
	lw $t9, 0($sp)						# load reversed array
	addi $sp, $sp, 8					# deallocate space 
######################################### FOR PRINT EVERY NTH 
	li $v0, 4							# print string
	la $a0, new_line_p					# load new line 
	syscall 

	li, $v0, 4							# print String
	la, $a0, user_nth_p					# load user input 
	syscall

	li $v0, 5							# input
	syscall

	move $t3, $v0						# move user input into t3

	addi $sp, $sp, -12					# space for ra, size, address, and N
	sw $ra, 12($sp)						# store return address
	sw $t0, 8($sp)						# store address
	sw $t1, 4($sp)						# store size 
	sw $t3, 0($sp)						# store user input n

	jal print_every_nth

	lw $t3, 0($sp)						# load user input n
	lw $t1, 4($sp)						# load size into t1
	lw $t0, 8($sp)						# load address
	lw $ra, 12($sp)						# load return address
	addi $sp, $sp, 12
#########################################

	
	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		Subprogram Description
#			Create Array
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 user input
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
array_length_p:       .asciiz   "Please enter array length: "
###########################################################
		.text
create_array:
	li $v0, 4
	la $a0, array_length_p		
	syscall

	li $v0, 5
	syscall

	move $t0, $v0

	addi $sp, $sp -8 					# allocate space for ra and returning array and length
	sw $ra, 8($sp)
	sw $t0, 0($sp)

	jal allocate_array
	jal read_values
	jr $ra	#return to calling location
###########################################################
###########################################################
#		Allocate Array
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0 
#	$v1 
#	$sp array base address
#	$sp+4 array size
#	$sp+8 new array size
#	$sp+12
###########################################################
#		Register Usage
#	$t0 
#	$t1 array length
#	$t2 
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
allocate_array_length_p:       .asciiz   "Please enter array length: "
allocate_array_negative_p:     .asciiz   "Invalid length ( n > 0 && n <21 )!\n"
###########################################################
		.text
allocate_array:
	lw $t1, 0($sp)

allocate_array_loop:

	blez $t1, allocate_array_neg_length # if (user input <= 0) -> allocate_array_neg_length
	bgt $t1, 20, allocate_array_neg_length #if user input >20

	li $v0, 9                           # $v0 <- 9 (setup syscall to allocate array)
	sll $a0, $t1, 2						# $a0 <- user input length * 2^2
	syscall								# $v0 <- array base address

	sw $v0, 4($sp)						# store array base address 
	sw $t1, 0($sp)                      # $v1 <- user input length

	b allocate_array_end				# -> allocate_array_end
	
allocate_array_neg_length:
	li $v0, 4                           # $v0 <- 4 (setup syscall to print string)
	la $a0, allocate_array_negative_p	# $a0 <- address of "allocate_array_negative_p"
	syscall

	li $v0, 4                           # $v0 <- 4 (setup syscall to print string)
	la $a0, allocate_array_length_p		# $a0 <- address of "allocate_array_length_p"
	syscall

	li $v0, 5                           # $v0 <- 5 (setup syscall to read integer)
	syscall								# $v0 <- user input length
	
	move $t1, $v0						# $t1 <- user input length

	b allocate_array_loop				# -> allocate_array_loop
	
allocate_array_end:

	jr $ra								# return to calling location
###########################################################
###########################################################
#		Read Values
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2 
#	$a3
#	$v0 
#	$v1
#	$sp array base address
#	$sp+4 array size
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2 constant 2
#	$t3 constant 3
#	$t4 
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9 
###########################################################
		.data
read_values_prompt_p:       .asciiz "Enter a non-negative odd integer: "
read_values_invalid_p:      .asciiz "Invalid Entry. Try Again\n"
###########################################################
		.text
read_values:

	lw $t0, 4($sp)                      # $t0 <- array base address (pointer)
	lw $t1, 0($sp)						# $t1 <- array size (counter)
	lw $ra, 8($sp)						# return to main 
	li $t2, 2							# $t2 <- 2
	li $t3, 3							# $t3 <- 3

read_values_loop:

	blez $t1, read_values_end			# if (counter <= 0) -> read_values_end

	li $v0, 4                          	# $v0 <- 4 (setup syscall to print string)
	la $a0, read_values_prompt_p		# $a0 <- base address of "read_values_prompt_p"
	syscall

	li $v0, 5                          	# $v0 <- 5 (setup syscall to read integer)
	syscall								# $v0 <- user input

	bltz $v0, read_values_invalid_entry # if (user input < 0) -> read_values_invalid_entry

	sw $v0, 0($t0)                   	# mem[pointer] <- valid input
	addi $t0, $t0, 4                 	# $t0 <- pointer + 4
	addi $t1, $t1, -1					# $t1 <- counter - 1
	
	b read_values_loop					# -> read_values_loop
	
read_values_invalid_entry:

	li $v0, 4                        	# $v0 <- 4 (setup syscall for print string)
	la $a0, read_values_invalid_p		# $a0 <- address of "read_values_invalid_p
	syscall
	
	b read_values_loop             		# -> read_values_loop

read_values_end:
	jr $ra	                            # return to calling location.   

###########################################################
###########################################################
#      			Print Array
#
###########################################################
#       Arguments IN and OUT of subprogram
#   $a0  
#   $a1  
#   $a2
#   $a3
#   $v0
#   $v1
#   $sp array size
#   $sp+4 array address
#   $sp+8
#   $sp+12
###########################################################
#       Register Usage
#   $t0  array address
#   $t1  array size
###########################################################
        .data
print_array_array_p:    .asciiz     "Array: "
print_array_space_p:    .asciiz     " " 
###########################################################
        .text
print_array:
    lw $t0, 4($sp)              # move array pointer (address) to $t0
    lw $t1, 0($sp)              # move array size (value) to $t1
    
    li $v0, 4                   # prints array is:
    la $a0, print_array_array_p
    syscall 
    
print_array_while:

    blez $t1, print_array_end   # branch to print_array_end if counter is less than or equal to zero
    
    li $v0, 1
    lw $a0, 0($t0)              # $a0 <-- memory[$t0 + 0]
    syscall                     # load a value from memory to register $a0
    
    li $v0, 4                   # space character
    la $a0, print_array_space_p
    syscall 
  
    addi $t0, $t0, 4            # increment array pointer (address) to next word (each word is 4 bytes)
    addi $t1, $t1, -1           # decrement array counter (index)
    b print_array_while         # branch unconditionally back to beginning of the loop
    
print_array_end:
    jr $ra                      #return to main 
########################################################### 

###########################################################
#		Subprogram Description
#			Print every nth
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp n 
#	$sp+4 size
#	$sp+8 address
#	$sp+12 ra
###########################################################
#		Register Usage
#	$t0 address
#	$t1	size max
#	$t2	n
#	$t3 size copy to count up 
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8 remainder
#	$t9 temp
###########################################################
		.data
every_nth_p:		.asciiz		"Every nth divisible position: "
space_p:    .asciiz     " " 
error_p: 			.asciiz		"Error. N is less than zero. "
###########################################################
		.text
print_every_nth:
	lw $t2, 0($sp)					# load n
	lw $t1, 4($sp)					# load size
	lw $t0, 8($sp)					# load base address
	li $t3, 0						# load 0 

	li $v0, 4						# print string
	la $a0, every_nth_p
	syscall

print_every_nth_loop:

	ble $t2, 0, print_every_nth_error	# error if n<=0
	bge $t3, $t1, print_every_nth_end	# end if counter t3=t1

	rem $t8, $t3, $t2					# divide t1 element by n

	beqz $t8, print_every_nth_print		# if index equals zero, branch

	addi $t0, $t0, 4					# move address pointer
	addi $t3, $t3, 1					# increment counter

	b print_every_nth_loop

print_every_nth_print:	

	li $v0, 1							# print element
	lw $a0, 0($t0)					
	syscall

	li $v0, 4							# print space
	la $a0, space_p
	syscall

	addi $t0, $t0, 4					# move address pointer
	addi $t3, $t3, 1					# decrement counter

	b print_every_nth_loop

print_every_nth_error:
	
	li $v0, 4
	la $a0, error_p
	syscall

print_every_nth_end:

	jr $ra	#return to calling location
###########################################################
###########################################################
#		Subprogram Description
#			Sum Odds Values
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp sum OUT
#	$sp+4 size IN
#	$sp+8 address IN
#	$sp+12 ra IN
###########################################################
#		Register Usage
#	$t0 base address
#	$t1 size
#	$t2 remainder
#	$t3 sum
#	$t4 element number
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data

###########################################################
		.text
sum_odd_values:
	lw $t0, 8($sp)			# load in base address
	lw $t1, 4($sp)			# load in size
	li $t3, 0				# sum=0

sum_odd_values_loop:

	ble $t1, 0, sum_odd_values_end 	# branch when counter 0

	lw $t4, 0($t0)

	rem $t2, $t4, 2			# div element by 2 store in t2	

	beqz $t2, sum_odd_values_even	# if even branch 

	add $t3, $t3, $t4		# add odd number to total sum

	addi $t0, $t0, 4		# move onto next element
	addi $t1, $t1, -1		# decrease counter

	b sum_odd_values_loop

sum_odd_values_even:

	addi $t0, $t0, 4		# move onto next element
	addi $t1, $t1, -1		# decrease counter
	b sum_odd_values_loop 	# branch to loop

sum_odd_values_end:
	
	sw $t3, 0($sp)			# store sum into stack
	jr $ra	#return to calling location
###########################################################
###########################################################
#			Reverse Array
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 array base address
#	$a1 array length
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp reverse OUT
#	$sp+4 array size
#	$sp+8 array address
#	$sp+12 ra 
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2 reverse array address
#	$t3 reverse array copy 
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9 temp
###########################################################
		.data
reverse_array_p:    .asciiz     "Array: "
reverse_array_space_p:    .asciiz     " " 

###########################################################
		.text
reverse_array:

	lw $t0, 8($sp)                      # $t0 <- array base address (pointer)
	lw $t1, 4($sp)                      # $t1 <- array length (counter)
	addi $sp, $sp, 12

	addi $sp, $sp, -8 					# allocate space for out and in
	sw $ra, 8($sp)						# store ra
	sw $t1, 0($sp)						# store size 
	
	jal allocate_array 					# jump and link allocate array
	
	lw $ra, 8($sp)						# load ra
	lw $t1, 0($sp)						# load size
	lw $t2, 4($sp)						# load reverse array address
	move $t3, $t2
	addi $sp, $sp, 8

    li $v0, 4                   		# prints array is:
    la $a0, reverse_array_p
    syscall 

	addi $t9, $t1, -1			  		# $t9 <- array length - 1 (index of last element)
	sll $t9, $t9, 2						# $t9 <- index of last element * 2^2 (memory size of all elements in front)
	add $t0, $t0, $t9					# $t0 <- base address + memory size (pointer to last element)

reverse_array_loop:

	blez $t1, reverse_array_end       # if (counter <= 0) -> print_backwards_end

	lw $t9, 0($t0)
	sw $t9, 0($t3)
	
	li $v0, 1							# $v0 <- 1 (setup syscall to print integer
	lw $a0, 0($t3)						# $a0 <- mem[pointer]
	syscall

	li $v0 4							# $v0 <- 4 (setup syscall to print string)
	la $a0, reverse_array_space_p		# $a0 <- address of "print_backwards_tab_p"
	syscall

	addi $t1, $t1, -1					# $t1 <- counter - 1
	addi $t0, $t0, -4					# $t0 <- counter - 4
	addi $t3, $t3, 4					# increment reverse by 4

	b reverse_array_loop				# -> print_backwards_loop

reverse_array_end:
	sw $t2, 0($sp)						# send back reverse array address

	jr $ra								# return to calling location
###########################################################