###########################################################
#		Program Description

###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array size
# 	$t2 LOWER array address
# 	$t3 LOWER array size
# 	$t4 HIGHER array address
#	$t5 HIGHER array size
#######
#   $f4 partition value
#   $f5 partition value
#######
#   $f6 LOWER average
#   $f7 
#######
#	$f8 HIGHER average
#	$f9 
###########################################################
		.data
partition_value_p:	.asciiz		"\nPlease enter the partition value: "
print_space_p:   	.asciiz    	" "   
print_lower_p:	 	.asciiz		"Lower average: "
print_higher_p:	 	.asciiz		"Higher average:"
print_newline_p: 	.asciiz		"\n"
###########################################################
		.text
main:
	jal create_array 		# jump and link to create array
	jal print_double_array 	# jump and link to print double array

	lw $t0, 0($sp)			# load base addresss into t0
	lw $t1, 4($sp)			# load array size into t1
	lw $ra, 8($sp)			# load return address
	addi $sp, $sp, 8		# deallocate space 
########################################################### Parititon 
	li $v0, 4
	la $a0, partition_value_p 
	syscall 				# print prompt for partition value

	li $v0, 7
	syscall					# read in double precision number -> f0

	mov.d $f4, $f0			# move input to f4

	addi $sp, $sp, -32		# allocate space for partition array
	sw $t0, 0($sp)			# store base address
	sw $t1, 4($sp)			# store array size
	s.d $f4, 8($sp)			# store partition value

	jal partition_array		# jump and link to partition array

	l.d $f4, 8($sp)			# load partition value 
	lw $t2, 16($sp)			# load LOWER address
	lw $t3, 20($sp)			# load LOWER size
	lw $t4, 24($sp)			# load HIGHER address
	lw $t5, 28($sp)			# load HIGHER size
	addi $sp, $sp, 32 		# deallocate space from stack
############################################################ PRINT SEPARATE ARRAYS
	sw $t2, 0($sp)			# store LOWER address
	sw $t3, 4($sp)			# store LOWER size

	jal print_double_array  # jump and link to print LOWER array

	li $v0, 4
	la $a0, print_newline_p # print new line
	syscall

	sw $t4, 0($sp)			# store HIGHER address
	sw $t5, 4($sp)			# store HIGHER size

	jal print_double_array  # jump and link to print HIGHER array

	li $v0, 4
	la $a0, print_newline_p # print new line
	syscall
############################################################ GET SUM AND AVERAGE
	addi $sp, $sp, -20		# allocate space for get average
	sw $t2, 0($sp)			# store LOWER address
	sw $t3, 4($sp)			# store LOWER size
	sw $ra, 16($sp)			# store ra

	jal get_average 		# jump and link to get average

	lw $t2, 0($sp)			# load LOWER address
	lw $t3, 4($sp)			# load LOWER size
	l.d $f6, 8($sp)			# load LOWER average
	lw $ra, 16($sp)			# load ra
	addi $sp, $sp, 20		# deallocate space
#############################
	addi $sp, $sp, -28		# allocate space for get average
	sw $t4, 0($sp)			# store HIGHER address
	sw $t5, 4($sp)			# store HIGHER size
	s.d $f6 16($sp)
	sw $ra, 24($sp)

	jal get_average 		# jump and link to get average

	lw $t4, 0($sp)			# load HIGHER address
	lw $t5, 4($sp)			# load HIGHER size
	l.d $f8, 8($sp)			# load HIGHER average
	l.d $f6, 16($sp)
	lw $ra, 24($sp)			# load ra
	addi $sp, $sp, 28		# deallocate space

############################################################ PRINT RESULTS
	li $v0, 4
	la $a0, print_lower_p
	syscall

	li $v0, 3
	mov.d $f12, $f6
	syscall

	li $v0, 4
	la $a0,  print_newline_p
	syscall

	li $v0, 4
	la $a0, print_higher_p
	syscall

	li $v0, 3
	mov.d $f12, $f8
	syscall

	li $v0, 4
	la $a0,  print_newline_p
	syscall
############################################################

	li $v0, 10		#End Program
	syscall
###########################################################
#		Subprogram Description
# 			Create Array
###########################################################
#		Arguments In and Out of subprogram
#	$sp array base address (OUT)
#	$sp+4 array size (OUT)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 
#	$t1 array size
#	$t2
#   $f4 
#   $f5 
#   $f6 
#   $f7 
###########################################################
		.data
create_array_prompt_p:  .asciiz "Please enter the array size (greater than 6): "
create_array_error_p:   .asciiz "Invalid, array size should be > 6!\n"
###########################################################
		.text
create_array:
    li $v0, 4
    la $a0, create_array_prompt_p       # prompt user to input array size
    syscall

    li $v0, 5                           # user input
    syscall

    ble $v0, 6, create_array_error      # branch to error if input<6

    move $t1, $v0                       # move size input to t1

    b create_array_end                  # brance to end 

create_array_error:
    li $v0, 4
    la $a0, create_array_error_p        # print out error message
    syscall

    b create_array                      # brance to create array for input

create_array_end:
	addi $sp, $sp -8 					# allocate space for ra and returning array and length
	sw $ra, 8($sp)
	sw $t1, 4($sp)

	jal allocate_array
	jal read_array

	jr $ra	#return to calling location
###########################################################
###########################################################
#		Subprogram Description
# 			Allocate Array
###########################################################
#		Arguments In and Out of subprogram
#	$sp array size (IN)
#	$sp+4 array base address (OUT)
#	$sp+8 array size (OUT)
#	$sp+12
###########################################################
#		Register Usage
#	$t0
#	$t1 array size 
#	$t2
#   $f4 
#   $f5 
#   $f6 
#   $f7 
###########################################################
		.data
allocate_array_length_p:       .asciiz   "Please enter array length: "
allocate_array_negative_p:     .asciiz   "Invalid length ( n >0 )!\n"
###########################################################
		.text
allocate_array:
	lw $t1, 4($sp)			# load array size

allocate_array_loop:

	ble $t1, 6, allocate_array_neg_length # if (user input <= 0) -> allocate_array_neg_length

	li $v0, 9                           # $v0 <- 9 (setup syscall to allocate array)
	sll $a0, $t1, 3						# $a0 <- user input length * 2^3
	syscall								# $v0 <- array base address

	sw $v0, 0($sp)						# store array base address 
	sw $t1, 4($sp)                      # $v1 <- user input length

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

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
# 			Read Array
###########################################################
#		Arguments In and Out of subprogram
#	$sp array base address (IN)
#	$sp+4 array size (IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#   $t0 Holds array base address
#   $t1 Holds array size
#	$t2
#   $f4 
#   $f5 
#   $f6 
#   $f7 
###########################################################
		.data
read_array_prompt_p:  .asciiz "Please enter a value: "
###########################################################
		.text
read_array:
	lw $ra, 8($sp)
    lw $t1, 4($sp)              # load array size
    lw $t0, 0($sp)              # load array address

read_array_loop:

    blez $t1, read_array_loop_end           # branch when count<=0

    li $v0, 4
    la $a0, read_array_prompt_p             # print out prompt
    syscall

    li $v0, 7                               # read a double precision #
    syscall

    s.d $f0, 0($t0)                         # store input into array

    addi $t0, $t0, 8                        # move pointer
    addi $t1, $t1, -1                       # counter - 1

    b read_array_loop

read_array_loop_end:

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
# 				Print Array
###########################################################
#		Arguments In and Out of subprogram
#	$sp array base address (IN)
#	$sp+4 array size (IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#   $t0         Holds array index address
#   $t1         Holds array length/loop countdown
#   $f12|$f13   Holds array value
###########################################################
		.data
print_double_array_prompt_p:   .asciiz     "Array: "
print_double_array_space_p:    .asciiz     " "        
###########################################################
        .text
print_double_array:
    lw $t0, 0($sp)			# load address
    lw $t1, 4($sp)			# load size 

    li $v0, 4
    la $a0, print_double_array_prompt_p
    syscall

print_double_array_loop:
    ble $t1, 0, print_double_array_end       # branch when count<=0

    li $v0, 3                                # print double precision #
    l.d $f12, 0($t0)
    syscall

    li $v0, 4 
    la $a0, print_double_array_space_p
    syscall

    addi $t1, -1                             # countdown loop
    addi $t0, 8                              # move array pointer

    b print_double_array_loop

print_double_array_end:
    jr $ra                  # jump back to the main
###########################################################

###########################################################
#		Subprogram Description
# 				Partition Array
###########################################################
#		Arguments In and Out of subprogram
#	$sp source array base address (IN)
#	$sp+4 source array size (IN)
#	$sp+8 partition value,double precision (IN)
#	$sp+16 "less" array base address (OUT)
# 	$sp+20 "less" array size (OUT)
# 	$sp+24 "greater" array base address (OUT)
# 	$sp+28 "greater" array size (OUT)
###########################################################
#		Register Usage
#	$t0 base address
#	$t1 array size/counter
#	$t2 array size back up/counter 2
# 	$t3 number of values < partition / temp
# 	$t4 address for LOWER values
# 	$t5 address for HIGHER values
#######
#   $f4 parititon value
#   $f5 partition value
#######
#   $f6 current value
#   $f7 current value
###########################################################
		.data

###########################################################
		.text
partition_array:
	lw $t0, 0($sp)					# load base address
	lw $t1, 4($sp)					# load size/counter
	lw $t2, 4($sp)					# load size/backup
	l.d $f4, 8($sp)					# load partition value
	li $t3, 0						# t3=0 for num of values<partition

partition_array_sizes:
	blez $t1, partition_array_sizes_allocate 		# branch to end counter<=0

	l.d $f6, 0($t0)					# load element into f6

	c.lt.d $f6, $f4					# compare f6<f4
	bc1t partition_array_counter 	# branch if ^ is true 

	addi $t0, $t0, 8				# addi 8 to move pointer
	addi $t1, $t1, -1				# decrement counter

	b partition_array_sizes 		# branch back to loop

partition_array_counter:

	addi $t3, $t3, 1				# increment value counter by 1

	addi $t0, $t0, 8				# addi 8 to move pointer
	addi $t1, $t1, -1				# decrement counter

	b partition_array_sizes 		# branch back to loop

partition_array_sizes_allocate:
	li $v0, 9                       # $v0 <- 9 (setup syscall to allocate array)
	sll $a0, $t3, 8					# $a0 <- LOWER value size * 2^3
	syscall							# $v0 <- array base address

	move $t4, $v0					# move LOWER value address to t4
	sw $t4, 16($sp)					# store LOWER address onto stack
	sw $t3, 20($sp)					# store LOWER size onto stack

	sub $t3, $t2, $t3				# t2-t3=t3 array size-LOWER size in t3 HIGHER value

	li $v0, 9                       # $v0 <- 9 (setup syscall to allocate array)
	sll $a0, $t3, 8					# $a0 <- HIGHER value size * 2^3
	syscall							# $v0 <- array base address

	move $t5, $v0					# move LOWER value address to t5
	sw $t5, 24($sp)					# store HIGHER addresss onto stack
	sw $t3, 28($sp)					# store HIGHER size onto stack

	lw $t0, 0($sp)					# reload base address


partition_array_store:
	blez $t2, partition_array_store_end		# branch when counter <=0

	l.d $f6, 0($t0)					# load element into f6

	c.lt.d $f6, $f4					# compare f6<f4
	bc1t partition_array_LOWER		# branch to store in LOWER array
	bc1f partition_array_HIGHER		# branch to store in HIGHER array

partition_array_LOWER:
    s.d $f6, 0($t4)                 # store input into array

	addi $t4, $t4, 8				# addi 8 to move pointer
	addi $t0, $t0, 8				# addi 8 to move pointer
	addi $t2, $t2, -1				# decrement counter
	b partition_array_store 		# branch back to loop

partition_array_HIGHER:
 	s.d $f6, 0($t5)                 # store input into array

	addi $t5, $t5, 8				# addi 8 to move pointer
	addi $t0, $t0, 8				# addi 8 to move pointer
	addi $t2, $t2, -1				# decrement counter
	b partition_array_store 	 	# branch back to loop

partition_array_store_end:



	jr $ra	#return to calling location
###########################################################
#		Subprogram Description
# 			Get Sum
###########################################################
#		Arguments In and Out of subprogram
#	$sp array base addresss (IN)
#	$sp+4 array size(IN)
#	$sp+8 sum of all elements (OUT) double
#	$sp+12 
#   $sp+16 ra 
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array size
#	$t2 
#######
#   $f4 sum
#   $f5 
#######
#   $f6 average 
#   $f7 
###########################################################
		.data

###########################################################
		.text
get_sum:
	lw $t0, 0($sp)			# load base address
	lw $t1, 4($sp)			# load array size
	li.d $f4, 0.0			# load sum=0
	blez $t1, get_sum_verify

get_sum_loop:
	blez $t1, get_sum_end	# branch to end counter<=0

	l.d $f6, 0($t0)			# load element into f6

	add.d $f4, $f4, $f6		# add f6 to total sum

	addi $t0, $t0, 8		# move pointer
	addi $t1, $t1, -1		# decrement counter

	b get_sum_loop			# branch to loop

get_sum_verify:
	li.d $f4, 0.0

get_sum_end:
	s.d $f4, 8($sp)			# store sum

	jr $ra	#return to calling location
###########################################################
#		Subprogram Description
#			Get Average
###########################################################
#		Arguments In and Out of subprogram
#	$sp array base addresss (IN)
#	$sp+4 array size(IN)
#	$sp+8 average (OUT) double 
#	$sp+12 
#   $sp+16 ra
###########################################################
#		Register Usage
#	$t0 array address
#	$t1 array size
#	$t2
#######
#   $f4 sum
#   $f5 
#######
#   $f6 average
#   $f7 
#######
#	$f8 size 
# 	$f9
###########################################################
		.data

###########################################################
		.text
get_average:
	lw $t0, 0($sp)			# load address
	lw $t1, 4($sp)			# load size
	blez $t1, get_average_verify

get_average_calc:
	mtc1 $t1, $f8			# move size to c1
	cvt.d.w $f8, $f8		# convert integer to double

	addi $sp, $sp, -20		# allocate space
	sw $t0, 0($sp)			# store address
	sw $t1, 4($sp)			# store size
	sw $ra, 16($sp)			# store ra

	jal get_sum				# jump and link to get sum

	lw $t0, 0($sp)			# load address
	lw $t1, 4($sp)			# load size
	l.d $f4, 8($sp)			# load sum
	lw $ra, 16($sp)			# load ra
	addi $sp, $sp, 20		# deallocate space


	div.d $f6, $f4, $f8		# divide sum by size for average
	b get_average_end

get_average_verify:
	li.d $f6, 0.0

get_average_end:
	s.d $f6, 8($sp)			# OVERWRITE SUM store average onto stack 

	jr $ra	#return to calling location
###########################################################



