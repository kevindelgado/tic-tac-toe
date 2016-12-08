        .text

main: 

	######  README ######
	#
	# Notes on turning SPIM into FPGA:
	# Remove stuff at top and exit
	# Load into $2 at start, instead of via syscall
	# Comment out all syscalls
	# Dvide immediates by 4
	# Add nops to every control flow
	#
	#####################

        addi $7, $0, 0      # Initialize $7 as global turn counter
        addi $19, $0, 1     # Set imm to 1 when not debugging 
	addi $5, $0, 0	    # Initalize game to 2p
	addi $8, $0, 1	    # Store 1 in temp to get swaure
	
	addi $14, $0, 8
	addi $25, $0, 0     # for debug purposes
	addi $6, $0, 0      # Random counter
        
start: 
	lw $2, 0($0)        # Commen this out when debugging
	jal inc_counter
        bne $0, $19, setup_loop
	nop
	nop
	nop
	nop
	nop

	blt $0, $25, do_jr
	nop
	nop
	nop
	nop
	nop
	addi $25, $25, 1    # Not first time anymore
	j debug_start
	nop
	nop
	nop
	nop
	nop

inc_counter:
	addi $8, $0, 23
	blt $6, $8, continue_count
	addi $6, $0, 0
	jr $31

continue_count:
	addi $6, $6, 1
	jr $31
 

do_jr: 
	jr $31
	nop
	nop
	nop
	nop
	nop
        
debug_start:
	addi $8, $0, 1
	#li $4, 256	    # Ask for 128 bytes (32 words)
	#li $2, 9            # Sbrk syscall v0
	#syscall             # Result is in $2

	sw $8, 0($2)        # switch 0 flipped
	jal setup_loop

	sw $8, 16($2)       # switch 4 flipped
	jal setup_loop

	sw $8, 32($2)       # switch 8 flipped	
	jal setup_loop

	sw $8, 36($2)      # switch 9 flipped (reset)
	jal setup_loop

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
	
        addi $9, $0, 1999  # Should not be reached

        
setup_loop: 
	addi $5, $31, 0    # Save return reg
	addi $20, $2, 0    # Reset current switch to sw0
	addi $21, $2, 13   # Reset prev_swith to sw0
	addi $14, $20, 9
	addi $15, $0, 0
	addi $18, $0, 8

loop:
	nop
	nop
	nop
	nop
	nop
	lw $16, 0($20)	   # Load current switch to $16 
	lw $17, 0($21)     # Load current prev_switch to $17
	nop
	nop
	nop
	nop
	nop
	bne $16, $17, chg  # Branch to change if they are diff
	nop
	nop
	nop
	nop
	nop
	addi $20, $20, 1   # Increment current switch
	addi $21, $21, 1   # Increment current prev_switch
	nop
	nop
	nop
	nop
	nop
	addi $15, $15, 1
	nop
	nop
	nop
	nop
	nop
        blt $18, $15, rchk # Branch to reset_check if last switch
	nop
	nop
	nop
	nop
	nop
			   # Make $14 temp
	j loop
	nop
	nop
	nop
	nop
	nop

chg: 
	nop
	nop
	nop
	nop
	nop
	blt $16, $17, turn_return
	nop
	nop
	nop
	nop
	nop
	addi $8, $0, 1
	and $8, $7, $8     # 8 should be 0 if x, 1 if o
	addi $8, $8, 1     # Value to be added to square
	addi $9 $20, 26    # Set $9 to address of square

	nop
	nop
	nop
	nop
	nop
	lw $10, 0($9)
	nop
	nop
	nop
	nop
	nop
	bne $10, $0, turn_return
	nop
	nop
	nop
	nop
	nop
	sw $8, 0($9)       # Set square
	nop
	nop
	nop
	nop
	nop
	addi $7, $7, 1
	nop
	nop
	nop
	nop
	nop
	j turn_made
	nop
	nop
	nop
	nop
	nop

turn_return:
	nop
	nop
	nop
	nop
	nop
	sw $16, 0($21)	   # Set prev_switch = switch
	nop
	nop
	nop
	nop
	nop
	j start
	nop
	nop
	nop
	nop
	nop

turn_made:
	nop
	nop
	nop
	nop
	nop
	bne $24, $0, add_rand
	nop
	nop
	nop
	nop
	nop
	j check_win
	nop
	nop
	nop
	nop
	nop

add_rand:
	nop 
	nop
	nop
	nop
	nop

	addi $8, $6, 0
	addi $9, $2, 26     # sq0 loc
	addi $11, $0, 2     # Always o for cpu
rand_loop:
	lw $10, 0($9)
	bne $10, $0 filled_square
	sw $11, 0($9)
	j check_win

filled_square:
	addi $9, $0, 1
	j rand_loop	    # Infinite loop will occur at end
	

win_return:
	nop
	nop
	nop
	nop
	nop
	addi $14, $0, 8    # OFF BY ONE LOOK HERE
	nop
	nop
	nop
	nop
	nop
	blt $14, $7, tie   # Branch if game is tie
	nop
	nop
	nop
	nop
	nop
			   # TODO: Make $14 temp
	nop
	nop
	nop
	nop
	nop
	j turn_return
	nop
	nop
	nop
	nop
	nop

check_win:
	nop
	nop
	nop
	nop
	nop
        addi $14, $2, 26
	nop
	nop
	nop
	nop
	nop


        addi $8, $14, 3           # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 1     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

       	addi $8, $14, 0    # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 1     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

        addi $8, $14, 6           # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 1     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

        addi $8, $14, 0    # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 3     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

        addi $8, $14, 1    # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 3     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

        addi $8, $14, 2    # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 3     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

        addi $8, $14, 0    # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 4     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

        addi $8, $14, 2    # Set init
	nop
	nop
	nop
	nop
	nop
        addi $9, $0, 2     # Set diff
	nop
	nop
	nop
	nop
	nop
        jal win_helper
	nop
	nop
	nop
	nop
	nop

        j win_return
	nop
	nop
	nop
	nop
	nop

win_helper:
	nop
	nop
	nop
	nop
	nop
        lw $10, 0($8)
	nop
	nop
	nop
	nop
	nop
        add $8, $8, $9
	nop
	nop
	nop
	nop
	nop
        lw $11 0($8)
	nop
	nop
	nop
	nop
	nop
        add $8, $8, $9
	nop
	nop
	nop
	nop
	nop
        lw $12, 0($8)
	nop
	nop
	nop
	nop
	nop

        and $10, $10, $11
	nop
	nop
	nop
	nop
	nop
        and $10, $10, $12
	nop
	nop
	nop
	nop
	nop
        addi $13, $10, 0
	nop
	nop
	nop
	nop
	nop
	lw $23, 35($2)
	nop
	nop
	nop
	nop
	nop

	addi $11, $0, 1
	nop
	nop
	nop
	nop
	nop
	blt $23, $11, win_valid
	nop
	nop
	nop
	nop
	nop

        jr $31
	nop
	nop
	nop
	nop
	nop

win_valid:
	nop	
	nop
	nop
	nop	
	nop
	sw $13, 35($2)
	nop
	nop
	nop
	nop
	nop
	jr $31
	nop
	nop
	nop
	nop
	nop

ai_mov:
	nop
	nop
	nop
	nop
	nop
	jr $31             # TODO: AI (Don't forget to inc turn)
	nop
	nop
	nop
	nop
	nop
tie:
	nop
	nop
	nop
	nop
	nop
	lw $23, 35($2)
	nop
	nop
	nop
	nop
	nop
	bne $23, $0, turn_return
	nop
	nop
	nop
	nop
	nop
	addi $22, $0, 3
	nop
	nop
	nop
	nop
	nop
	sw $22, 35($2)
	nop
	nop
	nop
	nop
	nop
	j turn_return
	nop
	nop
	nop
	nop
	nop
	 	          

bad_input: 
	nop
	nop
	nop
	nop
	nop
	j start
	nop
	nop
	nop
	nop
	nop

rchk: 
	nop
	nop
	nop
	nop
	nop
	lw $16, 0($20)
	nop
	nop
	nop
	nop
	nop
	lw $17, 0($21)
	nop
	nop
	nop
	nop
	nop
	bne $16, $17, rset_2p
	nop
	nop
	nop
	nop
	nop
	addi $20, $20, 1
	nop
	nop
	nop
	nop
	nop
	addi $21, $21, 1
	nop
	nop
	nop
	nop
	nop
	lw $16, 0($20)
	nop
	nop
	nop
	nop
	nop
	lw $17, 0($21)
	nop
	nop
	nop
	nop
	nop
	bne $16, $17, rset_1p_rand
	nop
	nop
	nop
	nop
	nop

	j start
	nop
	nop
	nop
	nop
	nop

rset_2p:
	nop
	nop
	nop
	nop
	nop
	addi $24, $0, 0
	nop
	nop
	nop
	nop
	nop
	j rset
	nop
	nop
	nop
	nop
	nop

rset_1p_rand:
	nop
	nop
	nop
	nop
	nop
	addi $24, $0, 0
	nop
	nop
	nop
	nop
	nop
	j rset
	nop
	nop
	nop
	nop
	nop


rset: 
	nop
	nop
	nop
	nop
	nop
	nop
	addi $7, $0, 0    # Reset turn counter
	sw $16, 0($21)    # Set prev_switch = switch
	addi $19, $2, 26   # save squre_0 loc
	addi $20, $0, 0

rset_loop:
	nop
	nop
	nop
	nop
	nop
	addi $14, $2, 35
	sw $0, 0($19)     # Store 0 to square loc
	addi $19, $19, 1  # Increment square
	nop
	nop
	nop
	nop
	nop
	blt $14, $19, rset_done
	nop
	nop
	nop
	nop
	nop
	j rset_loop

rset_done:
	nop
	nop
	nop
	nop
	nop
	jr $5
	nop
	nop
	nop
	nop
	nop
	
	

	
debug_exit:
        addi $2, $0, 10     # Set $v0 to 10 for exit syscall
        #syscall             # Exit

.data
	switch_0: .word 0x00004000
	#square_0: .word 0x00000010
	#game_over: .word 0x00000020
	#prev_switch_0: .word 0x00000040

