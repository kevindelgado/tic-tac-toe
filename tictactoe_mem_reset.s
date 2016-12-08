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
        
start: 
	lw $2, 0($0)        # Commen this out when debugging
        bne $0, $19, setup_loop
	nop
	nop
	nop
	nop
	nop

        
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
	#blt $16, $17, bad_input
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
	sw $8, 0($9)       # Set square
	nop
	nop
	nop
	nop
	nop
	#jal turn_made
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
	#jr $5		   # Game not over, keep going
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
	#bne $16, $17, rset
	bne $16, $17, start
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

rset: 
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
	#jr $5
	j start 
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
