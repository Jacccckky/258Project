################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Name, Student Number
# Student 2: Name, Student Number (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       2
# - Unit height in pixels:      2
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000


##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    # Initialize the game
    li $t1, 0xff0000 # $t1 = red
    li $t2, 0x00ff00 # $t2 = green
    li $t3, 0x0000ff # $t3 = blue
    li $t4, 0xc0c0c0
    lw $t0, ADDR_DSPL
    # Medical bottle drawing
    sw $t4, 304($t0)
    sw $t4, 316($t0)
    sw $t4, 432($t0)
    sw $t4, 444($t0)
    sw $t4, 560($t0)
    sw $t4, 572($t0)
    addi $t5, $t0, 520        # $t5 = Starting address for top line at row 256
    addi $t6, $t0, 3848 # $t6 = Starting address for bottom line 2 pixels above bottom row
    addi $t7, $t0, 564        
    # Draw Top Horizontal Line (row 256, skip columns 48 to 60)
top_horizontal:
    sw $t4, 0($t5)            # Paint pixel at current top address
    addi $t5, $t5, 4          # Move to the next pixel by 4 bytes (2-pixel width)
    bne $t5, $t7, top_horizontal

    addi $t5, $t0, 572        # $t5 = Starting address for top line at column 60
    addi $t7, $t0, 616  
continue_top_horizontal:
    sw $t4, 0($t5)            # Paint pixel at current top address
    addi $t5, $t5, 4          # Move to the next pixel by 4 bytes
    bne $t5, $t7, continue_top_horizontal
    
    addi $t5, $t0, 520        # $t5 = Starting address for top line at column 60
    addi $t7, $t6, 0 
    # Draw Bottom Horizontal Line
left_vertical:
    sw $t4, 0($t5)            # Paint pixel at current bottom address
    addi $t5, $t5, 128          # Move to the next pixel by 4 bytes
    bne $t5, $t7, left_vertical

    # Draw Left Vertical Line
    addi $t5, $t0, 612        # $t5 = Starting address for top line at column 60
    addi $t7, $t0, 3940 
right_vertical:
    sw $t4, 0($t5)            # Paint pixel at current bottom address
    addi $t5, $t5, 128          # Move to the next pixel by 4 bytes
    bne $t5, $t7, right_vertical
    addi $t5, $t0, 3848        # $t5 = Starting address for top line at column 60
    addi $t7, $t0, 3944 
bottom_horizontal:
    sw $t4, 0($t5)            # Paint pixel at current bottom address
    addi $t5, $t5, 4          # Move to the next pixel by 4 bytes
    bne $t5, $t7, bottom_horizontal
    addi $t5, $t0, 0        # $t5 = Starting address for top line at column 60
    addi $t7, $t0, 0 
    

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
