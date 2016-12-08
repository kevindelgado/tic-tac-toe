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
	j setup_loop

        
        
setup_loop: 
	addi $5, $31, 0    # Save return reg
	addi $20, $2, 0    # Reset current switch to sw0
	addi $21, $2, 13   # Reset prev_swith to sw0
	addi $14, $20, 9

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
	j start

chg: 
	nop
	nop
	nop
	nop
	nop
	addi $8, $0, 1
	addi $9 $20, 26    # Set $9 to address of square
	sw $8, 0($9)       # Set square
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
	j start		   # Game not over, keep going
	nop
	nop
	nop
	nop
	nop


.data
	switch_0: .word 0x00004000
	#square_0: .word 0x00000010
	#game_over: .word 0x00000020
	#prev_switch_0: .word 0x00000040
