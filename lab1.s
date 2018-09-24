
#
# CMPUT 229 Student Submission License
# Version 1.0
# Copyright 2018 Payas Singh
#
# Unauthorized redistribution is forbidden in all circumstances. Use of this
# software without explicit authorization from the author or CMPUT 229
# Teaching Staff is prohibited.
#
# This software was produced as a solution for an assignment in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada. This solution is confidential and remains confidential 
# after it is submitted for grading.
#
# Copying any part of this solution without including this copyright notice
# is illegal.
#
# If any portion of this software is included in a solution submitted for
# grading at an educational institution, the submitter will be subject to
# the sanctions for plagiarism at that institution.
#
# If this software is found in any public website or public repository, the
# person finding it is kindly requested to immediately report, including 
# the URL or other repository locating information, to the following email
# address:
#
#          payas@ualberta.ca
#
#---------------------------------------------------------------
# Assignment:           1
# Due Date:             September 24, 2018
# Name:                 Payas Singh
# Unix ID:              
# Lecture Section:      A1
# Instructor:           Jose Amaral
# Lab Section:          D05
# Teaching Assistant:   Kristen Newbury
# Collaborated with :  Debangana Ghosh
#---------------------------------------------------------------
.text

calculator:
    
    addi $s1,$s1, -1                          # $s1 <-- $s1 + -1
    addi $s2,$s2, -2                          # $s2 <-- $s2 + -2
    addi $s3,$s3, -3                          # $s3 <-- $s3 + -3

    loop:   
    	# checks if the value stored at the address is an operand or an operator.
    	# increments / decrements the addresses stored in $a0 and $a1 to get the next value
    	# the stack $a1 grows down. 

    	lw $t0, 0($a0)					# $t0 <-- MEM[0 + $a0]
        beq $t0, $s1, addition          # if val[$t0] == val[$s1] go to subroutine addition
        beq $t0, $s2, subtraction       # if val[$t0] == val[$s2] go to subroutine subtraction
        beq $t0, $s3, termination       # if val[$t0] == val[$s3] go to subroutine termination
        
        sw   $t0, 0($a1)                 # MEM[$a1 + 0] <-- $t0
        addi $a1, $a1, -4                # decrement the address in $a1 by 4 to get to the address of the next position where a new integer will be stored

        addi $a0, $a0, 4                 # increment the address in $a0 by 4 to get to the address of the next value 

        j loop


addition:
        # adds the values of the operands when -1 is encountered. -1 represents addition.

        lw $t3, 4($a1)                # pop out the value at the top, $t3 <-- MEM[4 + $a1]
        lw $t4, 8($a1)                # pop out the value just below the top, $t4 <-- MEM[4 + $a1]
        add $t5, $t3, $t4             # $t5 <-- $t3 + $t4
        sw  $t5, 8($a1)               # MEM[$a1 + 8] <-- $t5
        addi $a1, $a1, 4			  # increment the address stored in $a1 by 4 because two values were popped out and one new value was stored
        addi $a0, $a0, 4			  # increment the value of $a0 by 4 to get to the address of the next value. $a0 <-- $a0 + 4

        j loop						  # once this subroutine is finished, go back to the loop

subtraction:
		# subtracts the values of the operands when -2 is encountered. -2 represents subtraction.
        
        lw $t3, 4($a1)                 # $t3 <-- MEM[4 + $a1]
        lw $t4, 8($a1)                 # $t4 <-- MEM[4 + $a1]
        sub $t5, $t4, $t3              # $t5 <-- $t4 - $t3
        sw  $t5, 8($a1)                # MEM[$a1 + 8] <-- $t5
        addi $a1, $a1, 4			   # $a1 <-- $a1 + 4
        addi $a0, $a0, 4 			   # $a0 <-- $a0 + 4

        j loop

termination:
		# prints the value at the top of the stack.
		# terminates the subroutine calculator. 
		
		addi $a1, $a1, 4				# increment the address in $a1 by 4 to get the value at the top of the stack
        li  $v0 1
        lw $a0, 0($a1)					
        syscall							# print the value at the top of the stack

        jr $ra       					# jumps to main_done. $ra conatins the address of main_done.


