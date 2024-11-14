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
ADDR_DSPL: .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD: .word 0xffff0000
CAPSULE_COLOR1: .word 0   # First half color of the capsule
CAPSULE_COLOR2: .word 0   # Second half color of the capsule
CAPSULE_POS1: .word 0    # Position of the first half of the capsule
CAPSULE_POS2: .word 0    # Position of the second half of the capsule
ORIENTATION: .word 0     # 0 = horizontal, 1 = vertical
Red: .word 0xff0000   # Second half color of the capsule
Yellow: .word 0xffff00   # Second half color of the capsule
Blue: .word 0x0000ff   # Second half color of the capsule
Gray: .word 0xc0c0c0


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
    li $t2, 0xffff00 # $t2 = yellow
    li $t3, 0x0000ff # $t3 = blue
    li $t4, 0xc0c0c0 # $t4 = gray
    lw $t0, ADDR_DSPL # left top corner
    # start location
    sw $t4, 304($t0)
    sw $t4, 316($t0)
    sw $t4, 432($t0)
    sw $t4, 444($t0)
    sw $t4, 560($t0)
    sw $t4, 572($t0)
    
    
    
    addi $t5, $t0, 520
    addi $t6, $t0, 3848
    addi $t7, $t0, 564        
top_horizontal:
    sw $t4, 0($t5)
    addi $t5, $t5, 4
    bne $t5, $t7, top_horizontal

    addi $t5, $t0, 572
    addi $t7, $t0, 616  
continue_top_horizontal:
    sw $t4, 0($t5)
    addi $t5, $t5, 4
    bne $t5, $t7, continue_top_horizontal
    
    addi $t5, $t0, 520
    addi $t7, $t6, 0 
left_vertical:
    sw $t4, 0($t5)
    addi $t5, $t5, 128
    bne $t5, $t7, left_vertical
    addi $t5, $t0, 612
    addi $t7, $t0, 3940 
right_vertical:
    sw $t4, 0($t5)
    addi $t5, $t5, 128
    bne $t5, $t7, right_vertical
    addi $t5, $t0, 3848
    addi $t7, $t0, 3944 
bottom_horizontal:
    sw $t4, 0($t5)
    addi $t5, $t5, 4
    bne $t5, $t7, bottom_horizontal
    addi $t5, $t0, 0
    addi $t7, $t0, 0 

generate_capsule:
    # Generate the first random color
    li $v0, 42          # Syscall for random number generation
    li $a0, 0           # RNG ID
    li $a1, 6           # Upper limit (exclusive)
    syscall             # Random number in $a0

    # Map the random number to corresponding pairs
    li $t9, 0           # Set up a base register for comparison

    beq $a0, $t9, color_0   # If $a0 == 0
    li $t9, 1
    beq $a0, $t9, color_1   # If $a0 == 1
    li $t9, 2
    beq $a0, $t9, color_2   # If $a0 == 2
    li $t9, 3
    beq $a0, $t9, color_3   # If $a0 == 3
    li $t9, 4
    beq $a0, $t9, color_4   # If $a0 == 4
    li $t9, 5
    beq $a0, $t9, color_5   # If $a0 == 5

color_0:
    sw $t1, CAPSULE_COLOR1   # Store CAPSULE_COLOR1
    sw $t1, CAPSULE_COLOR2   # Store CAPSULE_COLOR2
    j draw_capsule           # Proceed to draw the capsule

color_1:
    sw $t3, CAPSULE_COLOR1   # Store CAPSULE_COLOR1
    sw $t3, CAPSULE_COLOR2   # Store CAPSULE_COLOR2
    j draw_capsule           # Proceed to draw the capsule

color_2:
    sw $t2, CAPSULE_COLOR1   # Store CAPSULE_COLOR1
    sw $t2, CAPSULE_COLOR2   # Store CAPSULE_COLOR2
    j draw_capsule           # Proceed to draw the capsule

color_3:
    sw $t1, CAPSULE_COLOR1   # Store CAPSULE_COLOR1
    sw $t3, CAPSULE_COLOR2   # Store CAPSULE_COLOR2
    j draw_capsule           # Proceed to draw the capsule
color_4:
    sw $t1, CAPSULE_COLOR1   # Store CAPSULE_COLOR1
    sw $t2, CAPSULE_COLOR2   # Store CAPSULE_COLOR2
    j draw_capsule           # Proceed to draw the capsule

color_5:
    sw $t3, CAPSULE_COLOR1   # Store CAPSULE_COLOR1
    sw $t2, CAPSULE_COLOR2   # Store CAPSULE_COLOR2
    j draw_capsule           # Proceed to draw the capsule

draw_capsule:
    lw $t1, CAPSULE_COLOR1    # Load first capsule color
    lw $t2, CAPSULE_COLOR2    # Load second capsule color
    lw $t3, ADDR_DSPL         # Base address of the display
    # Assume initial position at $t4 (e.g., row 0, column 32)
    # Draw the first pixel
    sw $t1, 308($t3)
    sw $t2, 312($t3)            # Draw the second pixel
    j game_loop               # Return to game loop

check_input:
    lw $t0, ADDR_KBRD     # Load keyboard base address
    lw $t1, 0($t0)        # Check if a key is pressed
    beqz $t1, no_input    # If no key is pressed, skip input handling
    lw $t2, 4($t0)        # Load ASCII of the pressed key

    li $t3, 'w'           # Rotate
    beq $t2, $t3, rotate_capsule
    li $t3, 'a'           # Move left
    beq $t2, $t3, move_left
    li $t3, 'd'           # Move right
    beq $t2, $t3, move_right
    li $t3, 's'           # Move down
    beq $t2, $t3, move_down
    
rotate_capsule:
    lw $t4, ORIENTATION   # Load current orientation
    li $t5, 0             # Horizontal orientation
    beq $t4, $t5, rotate_to_vertical

rotate_to_horizontal:
    # Update positions for horizontal rotation
    lw $t6, CAPSULE_POS1  # Load first position
    li $t7, 4             # Offset for horizontal rotation
    add $t8, $t6, $t7     # Calculate new position for second half
    sw $t8, CAPSULE_POS2  # Store updated position
    li $t5, 0
    sw $t5, ORIENTATION   # Set orientation to horizontal
    j game_loop

rotate_to_vertical:
    # Update positions for vertical rotation
    lw $t6, CAPSULE_POS1  # Load first position
    li $t7, 128           # Offset for vertical rotation
    add $t8, $t6, $t7     # Calculate new position for second half
    sw $t8, CAPSULE_POS2  # Store updated position
    li $t5, 1
    sw $t5, ORIENTATION   # Set orientation to vertical
    j game_loop
move_left:
    lw $t6, CAPSULE_POS1  # Load first position
    lw $t7, CAPSULE_POS2  # Load second position
    li $t8, -4            # Offset for left movement
    add $t6, $t6, $t8     # Move first half left
    add $t7, $t7, $t8     # Move second half left
    sw $t6, CAPSULE_POS1  # Store updated position
    sw $t7, CAPSULE_POS2  # Store updated position
    j game_loop

move_right:
    lw $t6, CAPSULE_POS1  # Load first position
    lw $t7, CAPSULE_POS2  # Load second position
    li $t8, 4             # Offset for right movement
    add $t6, $t6, $t8     # Move first half right
    add $t7, $t7, $t8     # Move second half right
    sw $t6, CAPSULE_POS1  # Store updated position
    sw $t7, CAPSULE_POS2  # Store updated position
    j game_loop

move_down:
    lw $t6, CAPSULE_POS1  # Load first position
    lw $t7, CAPSULE_POS2  # Load second position
    li $t8, 128           # Offset for downward movement
    add $t6, $t6, $t8     # Move first half down
    add $t7, $t7, $t8     # Move second half down
    sw $t6, CAPSULE_POS1  # Store updated position
    sw $t7, CAPSULE_POS2  # Store updated position
    j game_loop


no_input:
    j game_loop

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
    # 5. Go back to Step 1
    jal check_input       # Handle keyboard input
    j game_loop
