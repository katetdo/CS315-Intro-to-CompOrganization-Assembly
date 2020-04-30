###########################################################
#		Program Description

###########################################################
#		Register Usage
#	$t0	Holds user input/loop counter
#	$t1 Holds Sum
#	$t2 Holds Count
#	$t3	Holds Answer 
#	$t4 Fraction_part
#	$t5 Temporary2
#	$t6
#	$t7	Holds constant 12
#	$t8 Holds constant 60
#	$t9 Holds constant -1
###########################################################
		.data
creditPoints_p: .asciiz "Enter credit points [0,12]: "
error_p:		.asciiz "Error! The number you entered was invalid."
nextline_p:		.asciiz	"\n"
totalCreditsPoints_p: 	.asciiz "Total credit points earned: "
totalCreditHours_p: 	.asciiz "Total credit hours taken: "
GPA_p: 			.asciiz	"Your GPA is: "
period_p:		.asciiz	"."

sum_var: 		.word 0
count_var:		.word 0
constant60: 	.word 60
constant1: 		.word -1
constant12: 	.word 13
###########################################################
		.text
main:
	la $t1, sum_var
	la $t2, count_var
	la $t7, constant12
	la $t8, constant60
	la $t9, constant1

	lw $t1, 0($t1)
	lw $t2, 0($t2)
	lw $t7, 0($t7)
	lw $t8, 0($t8)
	lw $t9, 0($t9)


loop:
	beq $t8, $t2, endLoop	#branch when count equals 60

	li $v0, 4			#Enter credit points prompt
	la $a0, creditPoints_p
	syscall 

	li $v0, 5			#read integer
	syscall

	beq $t9, $v0, endLoop 	#branches to end if user input = -1
	ble $t7, $v0, error #braches to error if user input > 13
	blez $v0, error     #branches to error if input is negative


	addi $t2, $t2, 3	#adds 3 credits to count hours 
	add $t1, $v0, $t1	#adds credits to total sum 

	b loop				#Branch back to start of loop


error:
	li $v0, 4			#prints out error message
	la $a0, error_p
	syscall

	li $v0, 4			#prints out a new line
	la $a0, nextline_p
	syscall

	b loop              #branches back to loop

endLoop:

	li $v0, 4			#prints out total credit point message
	la $a0, totalCreditsPoints_p
	syscall

	li $v0, 1			#prints out total credit point integer
	move $a0, $t1
	syscall

	li $v0, 4			#prints out a new line
	la $a0, nextline_p
	syscall

	li $v0, 4			#prints out total credit hours message
	la $a0, totalCreditHours_p
	syscall

	li $v0, 1			#prints out total credit hours integer
	move $a0, $t2
	syscall

	li $v0, 4			#prints out a new line
	la $a0, nextline_p
	syscall

	div $t3, $t1, $t2	#divides credits (sum) by hours (counter)

	li $v0, 4			#prints out calculated GPA message
	la $a0, GPA_p
	syscall

	li $v0, 1			#prints out calculated GPA integer
	move $a0, $t3
	syscall

	li $v0, 4
	la $a0, period_p	#prints out decimal point
	syscall

	li $t0, 4			#sets up the counter
	rem $t4, $t1, $t2	#remainder of sum/count into t4: frac part
	#temp is $t5

decimalLoop:

	mul $t5, $t4, 10	#multiply frac part by 10

	div $a0, $t5, $t2

	li $v0, 1			#prints out calculated GPA integer decimal places		
	syscall

	rem $t4, $t5, $t2

	addi $t0, $t0, -1	
	bgtz $t0, decimalLoop


end:
	li $v0, 10		#End Program
	syscall
###########################################################

