###########################################################
#		Program Description

###########################################################
#		Register Usage
#	$t0 address
#	$t1 size
#	$t2 min 
#	$t3 max
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
#   $f4 sum
###########################################################
		.data
total: 			.asciiz		"\n\nTotal: "
min:			.asciiz		"\n\nItem with minimum 'value' is: "
max: 			.asciiz		"\nItem with maximum 'value' is: "
print_name_p:		.asciiz			"\n\tName: " 
print_price_p:		.asciiz			"\tPrice: "
print_count_p: 		.asciiz			"\tCount: "
###########################################################
		.text
main:
	jal allocate_structure
	jal read_structure
	jal print_structure

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8

	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	jal get_sum

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	l.s $f4, 8($sp)
	addi $sp, $sp, 12

	li $v0, 4
	la $a0, total
	syscall

	li $v0, 2
	mov.s $f12, $f4
	syscall

	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	jal get_min_max

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)	
	lw $t3, 12($sp)	
	addi $sp, $sp, 16
#######################
	li $v0, 4
	la $a0, min
	syscall

	li $v0, 4
	la $a0, print_name_p
	syscall

	li $v0, 4
	move $a0, $t2
	syscall

	li $v0, 4
	la $a0, print_price_p
	syscall

	li $v0, 2
	l.s $f12, 16($t2)
	syscall

	li $v0, 4
	la $a0, print_count_p
	syscall

	li $v0, 1
	lw $a0, 20($t2)
	syscall

#########################
	li $v0, 4
	la $a0, max
	syscall

	li $v0, 4
	la $a0, print_name_p
	syscall

	li $v0, 4
	move $a0, $t3
	syscall

	li $v0, 4
	la $a0, print_price_p
	syscall

	li $v0, 2
	l.s $f12, 16($t3)
	syscall

	li $v0, 4
	la $a0, print_count_p
	syscall

	li $v0, 1
	lw $a0, 20($t3)
	syscall



	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		Subprogram Description

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
#	$t0
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

###########################################################
		.text

	jr $ra	#return to calling location
###########################################################
###########################################################
#		Subprogram Description
#			Allocate Structure
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
#	$t0 base address
#	$t1	size 
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
prompt_size: 		.asciiz  		"Enter array size: "
###########################################################
		.text
allocate_structure:
	
	li $v0, 4
	la $a0, prompt_size
	syscall

	li $v0, 5
	syscall

	move $t1, $v0

	li $v0, 9
	mul $a0, $t1, 24
	syscall

	move $t0, $v0

	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
# 				Read structure
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
#	$t0 address
#	$t1 size
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
string: 		.asciiz 		"\nEnter item name: "
price: 			.asciiz			"Enter item price: "
count:			.asciiz			"Enter item count: "
###########################################################
		.text
read_structure:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
read_loop:
	blez $t1, read_end

	li $v0, 4
	la $a0, string
	syscall

	li $v0, 8
	move $a0, $t0
	li $a1, 16
	syscall

	addi $t0, $t0, 16

	li $v0, 4
	la $a0, price
	syscall

	li $v0, 6
	syscall

	mov.s $f4, $f0
	s.s $f4, 0($t0)

	addi $t0, $t0, 4

	li $v0, 4
	la $a0, count
	syscall

	li $v0, 5
	syscall

	sw $v0, 0($t0)

	addi $t0, $t0, 4
	addi $t1, $t1, -1
	b read_loop

read_end:

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
# 			print structure
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
#	$t0
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
print_table:		.asciiz			"\nData Table: "
print_name:			.asciiz			"\n\tName: " 
print_price:		.asciiz			"\tPrice: "
print_count: 		.asciiz			"\tCount: "
###########################################################
		.text
print_structure:
	lw $t0, 0($sp)
	lw $t1, 4($sp)

	li $v0, 4
	la $a0, print_table
	syscall

print_loop:
	blez $t1, print_end

	li $v0, 4
	la $a0, print_name
	syscall

	li $v0, 4
	move $a0, $t0
	syscall

	li $v0, 4
	la $a0, print_price
	syscall

	li $v0, 2
	l.s $f12, 16($t0)
	syscall

	li $v0, 4
	la $a0, print_count
	syscall

	li $v0, 1
	lw $a0, 20($t0)
	syscall

	addi $t0, $t0, 24
	addi $t1, $t1, -1
	b print_loop

print_end:

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
#				Get sum
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
#	$t0
#	$t1
#	$t2 
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9 temp
# 	$f4 sum
###########################################################
		.data

###########################################################
		.text
get_sum:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	li.s $f4, 0.0

sum_loop:
	blez $t1, sum_end

	lw $t9, 20($t0)
	mtc1 $t9, $f5
	cvt.s.w $f5, $f5

	l.s $f6, 16($t0)
	mul.s $f7, $f6, $f5

	add.s $f4, $f4, $f7

	addi $t0, $t0, 24
	addi $t1, $t1, -1

	b sum_loop

sum_end:
	s.s $f4, 8($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
#				Get min and max
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
#	$t0 base
#	$t1 size
#	$t2 min
#	$t3 max
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8				f8 is max
#	$t9   			f4 is min

###########################################################
		.data

###########################################################
		.text
get_min_max:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	l.s $f4, 16($sp)
	l.s $f8, 16($sp)

	move $t2, $t0
	move $t3, $t0

loop:
	blez $t1, loop_end

	lw $t9, 20($t0)
	mtc1 $t9, $f5
	cvt.s.w $f5, $f5

	l.s $f6, 16($t0)
	mul.s $f7, $f6, $f5

	c.lt.s $f7, $f4 		# f7<f4
	bc1t loop_min

	c.lt.s $f8, $f7			# f8<f7
	bc1t loop_max

	addi $t0, $t0, 24
	addi $t1, $t1, -1
	b loop

loop_min:
	move $t2, $t0
	mov.s $f4, $f7

	addi $t0, $t0, 24
	addi $t1, $t1, -1
	b loop

loop_max:
	move $t3, $t0
	mov.s $f8, $f7

	addi $t0, $t0, 24
	addi $t1, $t1, -1
	b loop

loop_end:
	sw $t2, 8($sp)
	sw $t3, 12($sp)

	jr $ra	#return to calling location
###########################################################