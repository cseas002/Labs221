############################################################################
#Program Name		: A simple program that reads the 20 first lines from  
#						the .text and prints them on screen in binary or 
#						hex format by calling a function
#Programmer			: Petros Panayi	Stud. ID:000000
#Date Last Modif.	: 11 April 2021
#############################################################################
# Comments: 
#############################################################################
######## Stack Frame  Template #######
#Old $sp |-----------|
#		 |	 $s0	 |
#$fp-->  |-----------|
#		 |	 $s1	 |
#$sp+48->|-----------|
#		 |	 $s2	 |
#$sp+44->|-----------|
#		 |	 $s3	 |
#$sp+40->|-----------|
#		 |	 $s4	 |
#$sp+36->|-----------|
#		 |	 $s5	 |
#$sp+32->|-----------|
#		 |	 $s6	 |
#$sp+28->|-----------|
#		 |	 $s7	 |
#$sp+24->|-----------|
#		 |	 $fp	 |
#$sp+20->|-----------|
#		 |	 $ra	 |
#$sp+16->|-----------|
#		 |	 $a0	 |
#$sp+12->|-----------|
#		 |	 $a1	 |
#$sp+8-> |-----------|
#		 |	 $a2	 |
#$sp+4-> |-----------|
#		 |	 $a3	 |
#$sp --> |-----------|
#
#### S.O.S. we do not store V registers ###################################
	.data					# data segment	
codeAddress: 	.word	0x00400000		# The start of the text segment
codeNumber: 	.word	20				# the number of code to store
newLine: 		.asciiz	"\n"			# New line
dot: 			.asciiz	"."				# The Dot
hexCode:		.asciiz	" 0x"			# The Dot
tab:			.asciiz	"\t"			# The Dot
f:				.asciiz "f"
e:				.asciiz "e"
d:				.asciiz "d"
c:				.asciiz "c"
bee:			.asciiz "b"
a:				.asciiz "a"
#########################################################################	
	.text					# text segment
	.globl main
main:	
	# We have to save all the registers used into stack
	subu $sp,$sp,56 	# Stack frame is 56 bytes long
	sw $a0, 12($sp) 	# Save Argument 0 ($a0)
	sw $ra, 16($sp) 	# Save return address
	sw $fp, 20($sp) 	# Save frame pointer
	sw $s0, 52($sp) 	# Save $s0 in stack
	sw $s1, 48($sp) 	# Save $s1 in stack
	sw $s2, 44($sp) 	# Save $s2 in stack
	sw $s3, 40($sp) 	# Save $s3 in stack
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	lw   $s0, codeNumber 	# Load the number of code into $s0 	=> $s0 = 20
	lw   $s1, codeAddress

# Read the instructions from the .text segment
Loop1:	

	lw  $s3, 0($s1)			# load into $t2 the first address of .text 	<-----------
	sw  $s3, 12($sp)		# Store the parameter to the function in a0				|
	jal PrintBinary			# Call Function PrintBinary								|
	la	$a0, tab 			# Print a new tab										|
	li	$v0, 4				# 														|
	syscall					# 														^
							#														|
	move $a0, $t0			#														|
	jal PrintBinaryDot		# Call Function PrintBinaryDot							|
	la	$a0, tab 			# Print a new tab										|
	li	$v0, 4				# 														|
	syscall					# 														^
							#														|
	move $a0, $t0			#														|
	jal PrintHex			# Call Function PrintHex								|
	addi $s1,$s1, 4			# $s1 = $s1 + 4		=> $s1 = 0x00400004					^
	addi $s0, $s0, -1		# $s0 = $s0 - 1 	=> $s0 = 19							|
	la	$a0, newLine 	# Print a new line											|
	li	$v0, 4			# 															|
	syscall				# 															|
	bnez $s0, Loop1		# ------------->---------------------------------------->---	
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Exit: Restore all the registers used.	
	lw $a0, 12($sp) 	# Restore old value of Argument 0 ($a0)
	lw $ra, 16($sp) 	# Restore old value of  return address
	lw $fp, 20($sp) 	# Restore old value of  frame pointer
	lw $s0, 52($sp) 	# Restore old value of  $s0 in stack
	lw $s1, 48($sp) 	# Restore old value of  $s1 in stack
	lw $s2, 44($sp) 	# Restore old value of  $s2 in stack
	lw $s3, 40($sp) 	# Restore old value of  $s3 in stack
	addu $sp,$sp,56 	# Pop stack 56 bytes long
	
	jr $ra				# main return


###################################################	
# Function PrintBinary whatever word is sent in $a0
###################################################
PrintBinary:
	 move $t0, $a0			# Moving $a0's value in $t0
	 
	# for (int i = 0; i < 32; i++)
	#    print(rol and 1)
	
	li	$v0, 5				# System Call Code for reading the integer 
	syscall					# Make the System Call
	move $t0,$v0			# Move the value to $t0
	
	li	$t2, 32				# Storing number 32 in a helper variable
	li 	$t1, 0				# int i = 0;
	
	FOR_LOOP:
		 bge	$t1, $t2, END_FOR_LOOP		# If (i >= 32) goto END_FOR_LOOP;
		 
		 rol	$t0, $t0, 1					# Rol the number by one bit left
		 andi	$t3, $t0, 1					# $t3 will be equal to $t1 & 1
		 
		 move	$a0, $t3					# Moves the value to $a0 to print it
		 li		$v0, 1						# System Call code for printing an integer on console
		 syscall							# Make the System Call
		 
		 addi $t1, $t1, 1					# i++
		 j	FOR_LOOP
	END_FOR_LOOP:
		 
	 jr $ra 				# Return to caller
###############################################################
# Function PrintBinaryDot with Dot whatever word is sent in $a0
###############################################################
PrintBinaryDot:	
	 move $t0, $a0			# Moving $a0's value in $t0
	 
	# for (int i = 0; i < 32; i++)
	#    print(rol and 1)
	
	li	$t2, 32				# Storing number 32 in a helper variable
	li 	$t1, 0				# int i = 0;
	li 	$t5, 0
	li	$t6, 4
	
	FOR_LOOP2:
		 bge	$t1, $t2, END_FOR_LOOP2		# If (i >= 32) goto END_FOR_LOOP;
		 
		 rol	$t0, $t0, 1					# Rol the number by one bit left
		 andi	$t3, $t0, 1					# $t3 will be equal to $t1 & 1
		 
		 move	$a0, $t3					# Moves the value to $a0 to print it
		 li		$v0, 1						# System Call code for printing an integer on console
		 syscall							# Make the System Call
		 
		 
		 
		 addi 	$t5, $t5, 1					# $t5 ++
		 
		 bne 	$t5, $t6, SKIP_DOT			# If ($t5 != 4) goto SKIP_DOT;
		 li		$t5, 0						# $t5 = 0
		 
		 la	$a0, dot						# Prints dot (.)
		 li	$v0, 4							# System Call code for printing a string on console
		 syscall							# Make the System Call
		 
		SKIP_DOT:
		 
		 addi $t1, $t1, 1					# i++
		 j	FOR_LOOP2
	END_FOR_LOOP2:
	
	 jr $ra 				# Return to caller		
	
#######################################################################
# Function PrintHex prints in HEX whatever whatever word is sent in $a0
#######################################################################
PrintHex:	 
	move $t0, $a0			# Moving $a0's value in $t0
	 
	# for (int i = 0; i < 32; i += 4)
	#    print(rol and 15) (15 = 1111 in binary)
	
	#li	$v0, 5				# System Call Code for reading the integer 
	#syscall				# Make the System Call
	#move $t0,$v0			# Move the value to $s0
	
	li	$t2, 32				# Storing number 32 in a helper variable
	li 	$t1, 0				# int i = 0;
	
	li	$t4, 15
	li	$t5, 14
	li	$t6, 13
	li	$t7, 12
	li	$t8, 11
	li	$t9, 10
	
	la	$a0, hexCode	# Prints 0x
	li	$v0, 4			# System Call code for printing a string on console
	syscall				# Make the System Call
	
	FOR_LOOP3:
		 bge	$t1, $t2, END_FOR_LOOP3		# If (i >= 32) goto END_FOR_LOOP;
		 
		 rol	$t0, $t0, 4					# Rol the number by four bits left
		 andi	$t3, $t0, 15				# $t3 will be equal to $t1 & 15
		 
		 beq 	$t3, $t4, IS_F
		 beq 	$t3, $t5, IS_E
		 beq 	$t3, $t6, IS_D
		 beq 	$t3, $t7, IS_C
		 beq 	$t3, $t8, IS_B
		 beq 	$t3, $t9, IS_A
		 
		 move	$a0, $t3					# Moves the value to $a0 to print it
		 li		$v0, 1						# System Call code for printing an integer on console
		 syscall							# Make the System Call
		 
		 CONTINUE:
		 
		 addi $t1, $t1, 4					# i += 4
		 j	FOR_LOOP3
	END_FOR_LOOP3:
	
	bge		$t1, $t2, SKIP
	
		
	IS_F:
		la	$a0, f 			# Prints F
		li	$v0, 4			# System Call code for printing a string on console
		syscall				# Make the System Call
		j	CONTINUE
		
	IS_E:
		la	$a0, e 			# Prints E
		li	$v0, 4			# System Call code for printing a string on console
		syscall				# Make the System Call
		j	CONTINUE
		
	IS_D:
		la	$a0, d 			# Prints D
		li	$v0, 4			# System Call code for printing a string on console
		syscall				# Make the System Call
		j	CONTINUE
		
	IS_C:
		la	$a0, c 			# Prints C
		li	$v0, 4			# System Call code for printing a string on console
		syscall				# Make the System Call
		j	CONTINUE
		
	IS_B:
		la	$a0, bee 		# Prints B
		li	$v0, 4			# System Call code for printing a string on console
		syscall				# Make the System Call
		j	CONTINUE
		
	IS_A:
		la	$a0, a			# Prints A
		li	$v0, 4			# System Call code for printing a string on console
		syscall				# Make the System Call
		j	CONTINUE	
		
	SKIP:
	 jr $ra 				# Return to caller
