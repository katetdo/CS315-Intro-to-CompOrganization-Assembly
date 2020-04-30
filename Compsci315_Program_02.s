###########################################################
#		Program Description

###########################################################
#		Register Usage
#	$t0	Returned sum from vector dot
#	$t1 user entered B
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7 
#	$t8 array X
#	$t9 array W
###########################################################
		.data
array_X: 		.word 5, 2, 6, 9, 13, 4, 8, 11
array_W: 		
.word 0
array_length: 	.word 8

bPrompt_p:			.asciiz "Please enter a bias number b: "
result_p:			.asciiz "Result: "
newLine_p:			.asciiz "\n"
x_p:				.asciiz "X: "
w_p:				.asciiz "W: "

###########################################################
		.text
main:
	li $v0, 4					#print out X:
	la $a0, x_p
	syscall

	la $a0, array_X				#move array address into a0
	la $a1, array_length		#move array length ADDRESS into a1
	lw $a1, 0($a1)				#moves arary length INTEGER into a1

	jal Print_Array

	li $v0, 4					#print out new line
	la $a0, newLine_p
	syscall

	la $a0, array_length		#move array length ADDRESS into a1
	lw $a0, 0($a0)				#move array length INTEGER into a1

	jal Allocate_Array

	la $t8, array_W				#moves array W into t8
	sw $v0, 0($t8)

	move $t9, $v0				#moves allocated array to t9
	move $a0, $t9				#moves array to a0 for read array
	la $a1, array_length		#move array length ADDRESS into a1
 	lw $a1, 0($a1)				#move array legnth INTEGER into a1
 
 	jal Read_Values             #jump and link to read values

 	li $v0, 4					#print out W:
	la $a0, w_p
	syscall

 	la $a0, array_W
 	lw $a0, 0($a0)
 	la $a1, array_length		#move array length ADDRESS into a1
 	lw $a1, 0($a1)				#move array legnth INTEGER into a1

 	jal Print_Array   	        #jump and link to print array W

 	li $v0, 4					#print out new line
	la $a0, newLine_p
	syscall

	#move into registers for jal vector dot
	la $t8, array_W				#move array W ADDRESS into t8
	lw $a0, 0($t8)				#move array W INTEGERS into a0

	la $a1, array_X				#move array X ADDRESS into t9

	la $a2, array_length		#move array length ADDRESS into a2
 	lw $a2, 0($a2)				#move array legnth INTEGER into a2

	jal Vector_Dot 				#jump and link to Vector Dot

	move $t0, $v0				#moves total sum into t0

	li $v0, 4					#print out for user input to B
	la $a0, bPrompt_p
	syscall

	li $v0, 5					#read integer
	syscall

	move $t1, $v0				#move user input into t1

	add $t0, $t0, $t1			#user input b + total sum from vector

	li $v0, 4					#print out Result: prompt
	la $a0, result_p
	syscall

	li $v0, 1					#print out total sum
	move $a0, $t0
	syscall

	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		Subprogram Description
#		Allocate Array
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0	Array Length In
#	$a1
#	$a2
#	$a3
#	$v0	Array Out
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0	Array length
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
Allocate_Array:
	move $t0, $a0					#moves array length into t0

	li $v0, 9						#system call to allocate array
	sll $a0, $t0, 2					#makes space for array 
	syscall							#v0, new array base address

	jr $ra	#return to calling location
###########################################################
###########################################################
#		Subprogram Description
#	Read Values
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0	Array Address
#	$a1	Array Length
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
#	$t0 Array
#	$t1 Array Length
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7 temp
#	$t8 2
#	$t9 Divide remainder
###########################################################
		.data
newLine:			.asciiz "\n"
error_p:			.asciiz "Invalid Entry. Try Again."
arrayPrompt_p: 		.asciiz "Enter a non-negative odd integer also less than 10: "
###########################################################
		.text

Read_Values:
	move $t0, $a0		#Loads array into register t0
	move $t1, $a1		#Loads array length into register t1
	li $t9, 0			#Sets up counter to 0
	li $t8, 2

Read_Values_Loop:	
	beq $t1, $t9, Read_Values_Loopend	#branches to end if limit reached

	la $v0, 4				
	la $a0, arrayPrompt_p	#prompts for user input array
	syscall

	li $v0, 5				#read integer
	syscall


	div $v0, $t8			#divide by 2
	mfhi $t7
	beqz $t7, Read_Values_Error		#branch to error if an even number
	blez $v0, Read_Values_Error		#branch to error if less than 0
	bgeu $v0, 10, Read_Values_Error	#branch to error if more than 10


	sw $v0, 0($t0)			#moves input to array register

	addi $t9, $t9, 1		#update counter by 1
	addi $t0, $t0, 4		#update position of array

	b Read_Values_Loop	   	#branch back to loop

Read_Values_Error: 
	la $v0, 4
	la $a0, error_p
	syscall

	li $v0, 4					#print out new line
	la $a0, newLine
	syscall

	b Read_Values_Loop

Read_Values_Loopend:

	jr $ra	#return to calling location
###########################################################
###########################################################
#		Subprogram Description
#	Print Array
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 Array Address
#	$a1 Array Length
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
#	$t0	Counter, starts at 0
#	$t1 Loop Limit / Array Length
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9	Array
###########################################################
		.data
space_p: 	.asciiz " "
###########################################################
		.text
Print_Array:
	li $t0, 0			#Counter for the loop
	move $t9, $a0 		#puts the array into register 9
	move $t1, $a1		#Array Length/Amount of times it goes through the loop
	

Print_Array_Loop:
	beq $t1, $t0, Print_Array_LoopEnd #exits loop when counter hits 8
	
	li $v0, 1
	lw $a0, 0($t9)		#load current element from array
	syscall

	li $v0, 4			#print space
	la $a0, space_p
	syscall

	addi $t0, $t0, 1 	#update Counter 
	addi $t9, $t9, 4 	#add 4 bytes for next array position
	b Print_Array_Loop

Print_Array_LoopEnd:
	move $a0, $t9

	jr $ra	#return to calling location
###########################################################
###########################################################
#		Subprogram Description
#	Vector Dot
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 Array X
#	$a1 Array W
#	$a2	Array length
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 Array X
#	$t1	Array W
#	$t2 Array Length counter
#	$t3 Array X Value
#	$t4	Array W Value
#	$t5
#	$t6
#	$t7
#	$t8	Temp
#	$t9 Total Sum
###########################################################
		.data
newline:		.asciiz 	"\n"
###########################################################
		.text
Vector_Dot:
	move $t0, $a0			#move array X into t0	
	move $t1, $a1			#move array W into t1
	move $t2, $a2			#move array length into t2/counter

	li $t9, 0				#Starts total sum as 0

Vector_Dot_Loop: 
	blez $t2, Vector_Dot_LoopEnd	#branch to end when length counter equals zero

	lw $a0, 0($t0)					#load element from array X
	lw $a1, 0($t1)					#load element from array W

	mul $t8, $a0, $a1

	add $t9, $t9, $t8

	addi $t0, $t0, 4
	addi $t1, $t1, 4
	addi $t2, $t2, -1
	b Vector_Dot_Loop

Vector_Dot_LoopEnd:

	move $v0, $t9

	jr $ra	#return to calling location
###########################################################
