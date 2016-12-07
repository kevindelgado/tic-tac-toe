        .text
        .align 2
       	.globl main

main: 
        addi $7, $0, 0      # Initialize $7 as global turn counter
        addi $19, $0, 0     # Set imm to 1 when not debugging 
	addi $5, $0, 0	    # Initalize game to 2p
	addi $8, $0, 1	    # Store 1 in temp to get swaure
	
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
	addi $8, $0, 1
	li $4, 256	    # Ask for 128 bytes (32 words)
	li $2, 9            # Sbrk syscall v0
	syscall             # Result is in $2

	sw $8, 0($2)        # switch 0 flipped
	jal setup_loop

	sw $8, 16($2)       # switch 4 flipped
	jal setup_loop

	sw $8, 32($2)       # switch 8 flipped	
	jal setup_loop

	#sw $8, 36($2)      # switch 9 flipped (reset)
	#jal setup_loop

	sw $8, 4($2)        # switch 1 flipped	
	jal setup_loop
	
	sw $8, 8($2)        # switch 2 flipped	
	jal setup_loop

	sw $8, 12($2)       # switch 3 flipped	
	jal setup_loop

	sw $8, 20($2)       # switch 5 flipped	
	jal setup_loop

	sw $8, 24($2)       # switch 6 flipped	
	jal setup_loop

	sw $8, 28($2)       # switch 7 flipped	
	jal setup_loop

	j debug_exit	
	
        j change
        addi $9, $0, 1999  # Should not be reached

        
setup_loop: 
	addi $5, $31, 0    # Save return reg
	addi $20, $2, 0    # Reset current switch to sw0
	addi $21, $2, 52   # Reset prev_swith to sw0
	addi $14, $20, 33

loop:
	lw $16, 0($20)	   # Load current switch to $16 
	lw $17, 0($21)     # Load current prev_switch to $17
	bne $16, $17, chg  # Branch to change if they are diff
	addi $20, $20, 4   # Increment current switch
	addi $21, $21, 4   # Increment current prev_switch
        blt $14, $20, rchk # Branch to reset_check if last switch
			   # Make $14 temp
	j loop

chg: 
	blt $16, $17, bad_input
	addi $8, $0, 1
	and $8, $7, $8     # 8 should be 0 if x, 1 if o
	addi $8, $8, 1     # Value to be added to square
	addi $9 $20, 104   # Set $9 to address of square
	sw $8, 0($9)       # Set square
	jal turn_made
	sw $16, 0($21)	   # Set prev_switch = switch
	jr $5		   # Game not over, keep going

turn_made:
	addi $14, $0, 8
	addi $3, $31, 0    # TODO: clean up
	jal check_win      # Check if 3 in a row anywhere
	addi $7, $7, 1     # Increment turn from user input
	blt $14, $7, tie   # Branch if game is tie
			   # TODO: Make $14 temp
	#blt $0, $5, ai_mov # AI's turn + inc turn for ai
	jr $3		   # No tie, no win, 2p

check_win:
	addi $6, $31, 0
	addi $14, $2, 104
	
	addi $8, $14, 0	   # Set init
	addi $9, $0, 4     # Set diff
	jal win_helper

	addi $8, $14, 12	   # Set init
	addi $9, $0, 4     # Set diff
	jal win_helper

	addi $8, $14, 24	   # Set init
	addi $9, $0, 4     # Set diff
	jal win_helper
		
	addi $8, $14, 0	   # Set init
	addi $9, $0, 12     # Set diff
	jal win_helper
	
	addi $8, $14, 4	   # Set init
	addi $9, $0, 12     # Set diff
	jal win_helper

	addi $8, $14, 8	   # Set init
	addi $9, $0, 12     # Set diff
	jal win_helper

	addi $8, $14, 0	   # Set init
	addi $9, $0, 16     # Set diff
	jal win_helper

	addi $8, $14, 8	   # Set init
	addi $9, $0, 8     # Set diff
	jal win_helper
	
	addi $31, $6, 0
	jr $31

win_helper:
	lw $10, 0($8)
	add $8, $8, $9
	lw $11 0($8)
	add $8, $8, $9
	lw $12, 0($8)
	
	and $10, $10, $11
	and $10, $10, $12
	addi $13, $10, 0
	
	jr $31
	




			   # Check 0, 1, 2
			   # Check 3, 4, 5
			   # Check 6, 7, 8
			   # Check 0, 3, 6
			   # Check 1, 4, 7
			   # Check 2, 6, 8
			   # Check 0, 4, 8
			   # Check 2, 4, 6
	jr $31		   # TODO: check if 3 in a row

ai_mov:
	jr $31             # TODO: AI (Don't forget to inc turn)
tie:
	addi $22, $0, 3
	sw $22, 140($2)
	jr $3
	 	          

bad_input: 
	j start

rchk: 
	lw $16, 0($20)
	lw $17, 0($21)
	bne $16, $17, rset
	j start

rset: 
	addi $7, $0, 0    # Reset turn counter
	sw $16, 0($21)    # Set prev_switch = switch
	addi $19, $2, 104   # save squre_0 loc
	addi $20, $0, 0

rset_loop:
	addi $14, $2, 137
	sw $0, 0($19)     # Store 0 to square loc
	addi $19, $19, 4  # Increment square
	blt $14, $19, rset_done
	j rset_loop

rset_done:
	jr $5
	
	
	

	
debug_exit:
        addi $2, $0, 10     # Set $v0 to 10 for exit syscall
        syscall             # Exit

.data
	switch_0: .word 0x00000000
	square_0: .word 0x00000010
	game_over: .word 0x00000020
	prev_switch_0: .word 0x00000040
