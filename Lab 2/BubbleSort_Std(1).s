#######################################################################################
#Program Name		: This Program uses     Bubble Sort to Sort n integer values
#Programmer		: Christoforos Seas	ID: 1028675
#Date Last Modif.	: 19 Sep. 2020
########################################################################################
# Comments: This Program uses Positive Bubble Sort to Sort
#	n integer values stored in .data.
########################################################################################

	.data		# data segment
#The table of 15 words
#int arr[] = {100, 64, 34, 25, 12, 101, 22, 11, 90, 132, 123, 110, 100, 8, 10, 111, 34, 55, 999, 19};
#int size = 20; 
table: 		.word 	100, 64, 34, 25, 12, 101, 22, 11, 90, 132, 123, 110, 100, 8, 10, 111, 34, 55, 999, 19	
size:		.word	20	#The size of the table
newLine:	.asciiz "\n"	#New line
comma:		.asciiz ", "	#Comma
unsortedArray:	.asciiz "Unsorted array:\n"	# Unsorted array
sortedArray:	.asciiz "Sorted array:\n"	# Sorted array
########################################################################################
	.text			# text segment
	.globl main
main:	
	# Initiate the values used in the program
	li $t0, 0		# set the counting value equal to 0
	
	li $v0, 4			# 4 = print questionStr syscall
	la $a0, unsortedArray		# load address of string
	syscall				# execute the system call
	
	la $a0, table	#Load the start address of the table
	lb $a1, size	#Load the size of the table
	jal printArray	#printArray(arr, size); 
	#-------------------------------------------------------------------
	# Call the Bubble Sort Function
	#-------------------------------------------------------------------
	la $a0, table	#Load the start address of the table
	lb $a1, size	#Load the size of the table
	jal bubbleSort
	#-------------------------------------------------------------------
	
	li $v0, 4			# 4 = print questionStr syscall
	la $a0, sortedArray		# load address of string
	syscall				# execute the system call
	
	
	la $a0, table	#Load the start address of the table
	lb $a1, size	#Load the size of the table
	jal printArray	#printArray(arr, size); 
	
	
	# Exit
	li	$v0, 10       #  Exit System Call
	syscall
	
######################################################################
###   Functions
#####################################################################	
printArray:
	 move $t0, $a0
	 move $t1, $a1
#-------------------------------------------------------------------
loop_prt:	
	lw $a0, 0($t0) 		#Load word from table
	li $v0, 1		#System Call print_int
	syscall			#Print on Console
	#Print on Console
	li $v0, 4		# 4 = print questionStr syscall
	la $a0, comma 		# load address of string
	syscall			# execute the system call
	addi $t0, $t0, 4	# Move the pointer to the next word
	addi $t1, $t1, -1	# Decrease the counter	
	bnez $t1, loop_prt	# Repeat until all words read
	
	li $v0, 4		# 4 = print questionStr syscall
	la $a0, newLine 	# load address of string
	syscall			# execute the system call
	
	
	jr $ra
#-------------------------------------------------------------------
#############################
######## Stack Frame  #######
#Old $sp|-----------|
#		|	 $s0	|
#$fp--> |-----------|
#		|	 $s1	|
#$sp+48	|-----------|
#		|	 $s2	|
#$sp+44	|-----------|
#		|	 $s3	|
#$sp+40	|-----------|
#		|	 $s4	|
#$sp+36	|-----------|
#		|	 $s5	|
#$sp+32	|-----------|
#		|	 $s6	|
#$sp+28	|-----------|
#		|	 $s7	|
#$sp+24	|-----------|
#		|	 $fp	|
#$sp+20 |-----------|
#		|	 $ra	|
#$sp+16	|-----------|
#		|	 $a0	|
#$sp+12	|-----------|
#		|	 $a1	|
#$sp+8	|-----------|
#		|	 $a2	|
#$sp+4	|-----------|
#		|	 $a3	|
#$sp -->|-----------|
#
#############################
bubbleSort:
	subu $sp,$sp,56 	# Stack frame is 56 bytes long
	sw $a0, 12($sp) 	# Save Argument 0 ($a0)
	sw $a1, 8($sp) 		# Save Argument 0 ($a0)
	
	sw $s0, 56($sp) 	# Save $s0
	sw $s1, 52($sp) 	# Save $s1
	sw $s2, 48($sp) 	# Save $s2
	sw $s3, 44($sp) 	# Save $s3
	sw $s4, 40($sp) 	# Save $s4
	sw $s5, 36($sp) 	# Save $s5
	sw $s6, 32($sp) 	# Save $s6
	sw $s7, 24($sp) 	# Save $s7
	
	sw $ra, 16($sp) 	# Save return address
	sw $fp, 20($sp) 	# Save frame pointer

	addiu $fp,$sp,52 	# Set up frame pointer
	
	move $s0, $a0		# $s0 = &Table
	move $s1, $a1		# $s1 = Size
	
	# *** ADD YOUR CODE HERE ***
	
	addi $s2, $0, 0	# $s2 = swapped = 0
	addi $s3, $0, 0	# $s3 = i = 0
	addi $s4, $0, 0	# $s4 = j = 0
firstForBubble:
	bge  $s3, $s1, endFirstForBubble	# if (i >= n) goto end of first for loop
	addi $s2, $0, 0	# swapped = 0
	secondForBubble:
		sub  $t0, $s1, $s3	# $t0 = Size (n) - i
		bge  $s4, $t0, endSecondForBubble	# if (j >= n) goto end of second for loop
	
		sll  $t0, $s4, 2	# $t0 = j * 4
		add  $t0, $t0, $s0      # $t0 = &Table + j * 4 
		# By this time, $t0 has the POSITION of arr[j]
		# We will now pass the value of arr[j] into $t1
		lw   $t1, 0($t0)
		# We will now add 4 to $t0 so we will have the POSITION of arr[j + 1]
		addi $t2, $t0, 4	# $t2 = $t0 + 4
		# Now register $t2 has the POSITION of arr[j + 1]
		# We will now pass the value of arr[j + 1] into $t3
		lw   $t3, 0($t2)
	
	
		# BY THIS TIME:
		# $t1 = arr[j]
		# $t3 = arr[j + 1]
	
		ble  $t1, $t3, endIfSecondFor # if (arr[j] <= arr[j + 1]) goto end of if statement
		# Now we are in if statement
		# We saved the return address so we can find it later
		# => We don't have to worry about it
		addi $a0, $s0, 0	# $a0 = arr
		addi $a1, $s4, 0	# $a1 = j
		addi $a2, $s4, 1	# $a2 = j + 1
		jal  swap
		addi $s2, $0, 1		# swapped = 1
		# End of if statement
		endIfSecondFor:
		
		addi $s4, $s4, 1	# j++
		j    secondForBubble
	endSecondForBubble:
	
	# Return if NO swap happened
	beqz $s2, Return	# if (swapped == 0) return;

	addi $s3, $s3, 1	# i++
	j    firstForBubble
endFirstForBubble:
	
Return: 				# Result is in $v0
	lw $s0, 56($sp) 	# Load $s0
	lw $s1, 52($sp) 	# Load $s1
	lw $s2, 48($sp) 	# Load $s2
	lw $s3, 44($sp) 	# Load $s3
	lw $s4, 40($sp) 	# Load $s4
	lw $s5, 36($sp) 	# Load $s5
	lw $s6, 32($sp) 	# Load $s6
	lw $s7, 24($sp) 	# Load $s7
	lw $ra, 16($sp) 	# Restore old value of $ra
	lw $fp, 20($sp) 	# Restore old value of $fp
	addiu $sp, $sp, 56 	# Pop stack
jr $ra

#-------------------------------------------------------------------
#swap(int arr[], int x, int y){
#	int temp = arr[x];
#	arr[x]=arr[y];
#	arr[y]=temp;
#}
swap: # ERROR if use: la $a0, table
	sll $a1, $a1, 2		#Compute the offset for x	
	sll $a2, $a2, 2 	#Compute the offset for y
	add $a1, $a1, $a0	#Compute the address of x
	add $a2, $a2, $a0	#Compute the address of y
	lw $t1, 0($a1)
	lw $t2, 0($a2)
	# Swap numbers
	sw $t2, 0($a1) 
	sw $t1, 0($a2) 
	jr $ra
#-------------------------------------------------------------------
