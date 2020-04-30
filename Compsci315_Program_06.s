###########################################################
#		Program Description

###########################################################
#		Register Usage
#	$t0 A: address / D
#	$t1 A: height/row / D
#	$t2 A: width/column / D
#	$t3 B: address
#	$t4 B: height
#	$t5 B: width
#	$t6 C: address
#	$t7 C: height
#	$t8 C: width
#	$t9
###########################################################
		.data
print_A: 		.asciiz		"\nMatrix A: \n"
print_B: 		.asciiz		"\nMatrix B: \n"
print_C:		.asciiz		"\nMatrix C: \n"
print_D:		.asciiz		"\nMatrix D: \n"

A_address: 		.word		0
A_height: 		.word		0
A_width: 		.word		0

B_address: 		.word		0
B_height: 		.word		0
B_width: 		.word		0

C_address:		.word		0
C_height:		.word		0
C_width:		.word		0

D_address: 		.word		0
D_height: 		.word		0
D_width: 		.word		0
###########################################################
		.text
main:
	jal create_col_matrix

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 12

	la $t9, A_address
	sw $t0, 0($t9)
	la $t9, A_height
	sw $t1, 0($t9)
	la $t9, A_width
	sw $t2, 0($t9)

	li $v0, 4
	la $a0, print_A
	syscall

	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)

	jal print_col_matrix

	addi $sp, $sp, 12

	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)

	jal transpose_col_matrix

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	addi $sp, $sp, 24

	la $t9, B_address
	sw $t3, 0($t9)
	la $t9, B_height
	sw $t4, 0($t9)
	la $t9, B_width
	sw $t5, 0($t9)

	li $v0, 4
	la $a0, print_B
	syscall

	addi $sp, $sp, -12
	sw $t3, 0($sp)
	sw $t4, 4($sp)
	sw $t5, 8($sp)

	jal print_col_matrix

	addi $sp, $sp, 12
######################################

	jal create_col_matrix

	lw $t6, 0($sp)
	lw $t7, 4($sp)
	lw $t8, 8($sp)
	addi $sp, $sp, 12

	la $t9, C_address
	sw $t6, 0($t9)
	la $t9, C_height
	sw $t7, 0($t9)
	la $t9, C_width
	sw $t8, 0($t9)

	li $v0, 4
	la $a0, print_C
	syscall

	addi $sp, $sp, -12
	sw $t6, 0($sp)
	sw $t7, 4($sp)
	sw $t8, 8($sp)

	jal print_col_matrix

	addi $sp, $sp, 12
#################################
	la $t9, B_address
	lw $t3, 0($t9)
	la $t9, B_height
	lw $t4, 0($t9)
	la $t9, B_width
	lw $t5, 0($t9)

	la $t9, C_address
	lw $t6, 0($t9)
	la $t9, C_height
	lw $t7, 0($t9)
	la $t9, C_width
	lw $t8, 0($t9)

	addi $sp, $sp, -36
	sw $t3, 0($sp)
	sw $t4, 4($sp)
	sw $t5, 8($sp)
	sw $t6, 12($sp)
	sw $t7, 16($sp)
	sw $t8, 20($sp)

	jal add_col_matrix

	lw $t0, 24($sp)
	lw $t1, 28($sp)
	lw $t2, 32($sp)
	addi $sp, $sp, 36

	la $t9, D_address
	sw $t0, 0($t9)
	la $t9, D_height
	sw $t1, 0($t9)
	la $t9, D_width
	sw $t2, 0($t9)

	blez $t0, end
	blez $t1, end
	blez $t2, end

print_matrix_D:
	li $v0, 4
	la $a0, print_D
	syscall

	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)

	jal print_col_matrix

	addi $sp, $sp, 12

end:
	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		Subprogram Description
#			create col matrix
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
#	$t1 height/row
#	$t2 width/column  
#	$t3 row index
#	$t4 width index
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
height_prompt: 		.asciiz	 	"\nEnter matrix height: "
width_prompt: 		.asciiz		"Enter matrix width: "
error_matrix: 		.asciiz		"Error. The value entered is <=0. "
input_prompt: 		.asciiz		"Enter a single: "
###########################################################
		.text
create_col_matrix:

height:
	li $v0, 4
	la $a0, height_prompt
	syscall

	li $v0, 5
	syscall

	blez $v0, error_height

	move $t1, $v0

width: 	
	li $v0, 4
	la $a0, width_prompt
	syscall

	li $v0, 5
	syscall

	blez $v0, error_width

	move $t2, $v0

	b allocate

error_height: 
	li $v0, 4
	la $a0, error_matrix
	syscall
	b height

error_width:
	li $v0, 4
	la $a0, error_matrix
	syscall
	b width

allocate:	
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $ra, 12($sp)

	jal allocate_col_matrix

	lw $t1, 0($sp)
	lw $t2, 4($sp)
	lw $t0, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16

	li $t3, 0

outer_loop:
	bge $t3, $t1, outer_end
	li $t4, 0

	inner_loop:
		bge $t4, $t2, inner_end
		mul $t9, $t1, $t4
		add $t9, $t9, $t3
		sll $t9, $t9, 2
		add $t9, $t9, $t0
		
		li $v0, 4
		la $a0, input_prompt
		syscall

		li $v0, 6
		syscall

		s.s $f0, 0($t9)

		addi $t4, $t4, 1

		b inner_loop

	inner_end:
		addi $t3, $t3, 1
		b outer_loop

outer_end:

	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)

	jr $ra	#return to calling location
###########################################################
###########################################################
#		Subprogram Description
# 			Allocate array
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
#	$t1 height
#	$t2 width
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
allocate_col_matrix:
	lw $t1, 0($sp)
	lw $t2, 4($sp)

	li $v0, 9
	mul $a0, $t1, $t2
	sll $a0, $a0, 2
	syscall

	sw $v0, 8($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
#			print column matrix
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp base address
#	$sp+4 height
#	$sp+8 width
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
print_space:		.asciiz			" "
print_newline:		.asciiz			"\n"
###########################################################
		.text
print_col_matrix:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)

	li $t3, 0							

print_outer_loop:
	bge $t3, $t1, print_outer_end
	li $t4, 0

	print_inner_loop:
		bge $t4, $t2, print_inner_end
		mul $t9, $t1, $t4
		add $t9, $t9, $t3
		sll $t9, $t9, 2
		add $t9, $t9, $t0

		li $v0, 2
		l.s $f12, 0($t9)
		syscall
		
		addi $t4, $t4, 1
		

		li $v0, 4
		la $a0, print_space
		syscall

		b print_inner_loop

	print_inner_end:
		addi $t3, $t3, 1

		li $v0, 4
		la $a0, print_newline
		syscall

		b print_outer_loop

print_outer_end:

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
#			Transpose column matrix
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
#	$t1 height 
#	$t2 width
#	$t3 B: address
#	$t4 B: height
#	$t5	B: width
#	$t6 height/row index
#	$t7 width/column index
#	$t8
#	$t9
###########################################################
		.data

###########################################################
		.text
transpose_col_matrix:
	lw $t0, 0($sp) 	# address
	lw $t1, 4($sp)	# height
	lw $t2, 8($sp)	# width

	move $t4, $t2	# make A width, B's height
	move $t5, $t1	# make A height, B's width

	addi $sp, $sp, -16
	sw $t4, 0($sp)
	sw $t5, 4($sp)
	sw $ra, 12($sp)
	sw $t0, 16($sp)

	jal allocate_col_matrix

	lw $t4, 0($sp)
	lw $t5, 4($sp)
	lw $t3, 8($sp)
	lw $ra, 12($sp)
	lw $t0, 16($sp)

	addi $sp, $sp, 16

	move $t2, $t4	# make A width, B's height
	move $t1, $t5	# make A height, B's width

	li $t6, 0	

trans_outer_loop:
	bge $t6, $t1, trans_out_end
	li $t7, 0

	trans_inner_loop:
		bge $t7, $t2, trans_inner_end

		mul $t8, $t1, $t7
		add $t8, $t8, $t6
		sll $t8, $t8, 2
		add $t8, $t8, $t0

		l.s $f4, 0($t8)

		mul $t9, $t2, $t6
		add $t9, $t9, $t7
		sll $t9, $t9, 2
		add $t9, $t9, $t3

		
		s.s $f4, 0($t9)

		addi $t7, $t7, 1

		b trans_inner_loop

	trans_inner_end:
		addi $t6, $t6, 1
		b trans_outer_loop

trans_out_end:

	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Subprogram Description
#			add matrix
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
#	$t0	B base	
#	$t1	B height
#	$t2 B width
#	$t3 C address
#	$t4 C ----height
#	$t5 C ----width
#	$t6 D address
#	$t7 D ----height
#	$t8 D ----width
#	$t9 temp
###########################################################
		.data
error_prompt: 		.asciiz	 	"\nCan't process matrix addition. Matrix shape doesn't match."
###########################################################
		.text
add_col_matrix:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)

	bne $t1, $t4, add_error
	bne $t2, $t5, add_error

create_matrix_D: 
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $ra, 12($sp)

	jal allocate_col_matrix

	lw $t7, 0($sp)
	lw $t8, 4($sp)
	lw $t6, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16

	li $t4, 0

add_outer_loop:
	bge $t4, $t1, add_out_end
	li $t5, 0

	add_inner_loop:
		bge $t5, $t2, add_inner_end

		mul $t8, $t2, $t4
		add $t8, $t8, $t5
		sll $t8, $t8 2
		add $t8, $t8, $t0

		mul $t9, $t2, $t4
		add $t9, $t9, $t5
		sll $t9, $t9, 2
		add $t9, $t9, $t3

		l.s $f4, 0($t8)
		l.s $f5, 0($t9)
		add.s $f6, $f4, $f5

		mul $t9, $t2, $t4
		add $t9, $t9, $t5
		sll $t9, $t9, 2
		add $t9, $t9, $t6

		s.s $f6, 0($t9)

		addi $t5, $t5, 1

		b add_inner_loop

	add_inner_end:
		addi $t4, $t4, 1
		b add_outer_loop

add_out_end:
	b add_end

add_error:
	li $v0, 4
	la $a0, error_prompt
	syscall
	
	li $t6, 0
	li $t1, 0
	li $t2, 0

add_end:
	sw $t6, 24($sp)
	sw $t1, 28($sp)
	sw $t2, 32($sp)

	jr $ra	#return to calling location
###########################################################

