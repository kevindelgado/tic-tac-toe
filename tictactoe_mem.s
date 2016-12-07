        .text
        .align 2
       	.globl main

main: 
        addi $7, $0, 0      # Initialize $7 as global turn counter
        addi $6, $23, 0     # Initialize $6 as the prev_switch_map
        addi $19, $0, 0     # Set imm to 1 when not debugging 
	addi $5, $0, 0	    # Initalize game to 2p
	addi $8, $0, 1	    # Store 1 in temp to get swaure
	addi $9, $0, 2	    # Store 2 in temp
	addi $10, $0, 3
	addi $11, $0, 4
	addi $12, $0, 9	    # Store number of board spots in temp
	addi $13, $0, 0
	
	#lw $16, 0($0)	    # Add switch_0 loc to store reg 
	#lw $17, 0($8)      # Add square_0 loc to store reg
	#lw $18, 0($11)     # Add prev_switch_0 loc to store reg
	addi $14, $0, 8
	addi $25, $0, 0     # for debug purposes
        
start: 
        bne $0, $19, setup_loop

	blt $0, $25, do_jr
	addi $25, $25, 1    # Not first time anymore
	j debug_start

do_jr: 
	jr $31
        
debug_start:
	#addi $5, $0, 0x10010000
	li $4, 256	    # Ask for 128 bytes (32 words)
	li $2, 9            # Sbrk syscall v0
	syscall             # Result is in $2
	sw $8, 0($2)        # switch 0 flipped
        nop 
        nop
	nop
	nop
	nop
	jal setup_loop
        nop 
        nop
	nop
	nop
	nop
	sw $8, 16($2)       # switch 5 flipped
        nop 
        nop
	nop
	nop
	nop
	jal setup_loop
        nop 
        nop
	nop
	nop
	nop
	sw $8, 32($2)       # switch 8 flipped
        nop 
        nop
	nop
	nop
	nop
	
	jal setup_loop
        nop 
        nop
	nop
	nop
	nop
	sw $8, 36($2)      # switch 9 flipped (reset)
        nop 
        nop
	nop
	nop
	nop
	jal setup_loop
        nop 
        nop
	nop
	nop
	nop
	j debug_exit	
	
	
	
	
        j change
        addi $22, $0, 1999  # Should not be reached

        
setup_loop: 
	addi $5, $31, 0    # Save return reg
	addi $13, $2, 0    # Reset current switch to sw0
	addi $11, $2, 52   # Reset prev_swith to sw0
	addi $14, $13, 33

loop:
	lw $16, 0($13)	   # Load current switch to $16 
	lw $18, 0($11)     # Load current prev_switch to $18
	bne $16, $18, chg  # Branch to change if they are diff
	addi $13, $13, 4   # Increment current switch
	addi $11, $11, 4   # Increment current prev_switch
        blt $14, $13, rchk # Branch to reset_check if last switch
			   # Make $14 temp
	j loop

chg: 
	blt $16, $18, bad_input
	and $20, $7, $8    # 20 should be 0 if x, 1 if o
	addi $21, $20, 1   # Value to be added to square
	addi $22 $13, 104  # Set $22 to address of square
	sw $21, 0($22)     # Set square
	jal turn_made
	sw $16, 0($11)	   # Set prev_switch = switch
	jr $5		   # Game not over, keep going

turn_made:
	addi $3, $31, 0    # TODO: clean up
	jal check_win      # Check if 3 in a row anywhere
	addi $7, $7, 1     # Increment turn from user input
	blt $14, $7, tie   # Branch if game is tie
			   # TODO: Make $14 temp
	#blt $0, $5, ai_mov # AI's turn + inc turn for ai
	jr $3		   # No tie, no win, 2p

check_win:
	jr $31		   # TODO: check if 3 in a row

ai_mov:
	jr $31             # TODO: AI (Don't forget to inc turn)
tie:
	addi $5, $0, 3
	 	          

bad_input: 
	j start

rchk: 
	lw $16, 0($13)
	lw $18, 0($11)
	bne $16, $18, rset
	j start

rset: 
	addi $7, $0, 0    # Reset turn counter
	#sw $0, 0($10)     # Reset game_over
	sw $16, 0($11)    # Set prev_switch = switch
	addi $19, $2, 104   # save squre_0 loc
	addi $14, $0, 8
	addi $13, $0, 0

rset_loop:
	addi $14, $2, 137
	sw $0, 0($19)     # Store 0 to square loc
	addi $19, $19, 4  # Increment square
	#addi $13, $13, 1   # increment loop counter
	blt $14, $19 start
	j rset_loop

	
	
	

	
debug_exit:
        addi $4, $0, 10     # Set $v0 to 10 for exit syscall
        syscall             # Exit

.data
	switch_0: .word 0x00000000
	square_0: .word 0x00000010
	game_over: .word 0x00000020
	prev_switch_0: .word 0x00000040
