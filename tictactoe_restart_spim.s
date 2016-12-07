        .text
	.align 2
	.globl main

main: 
        add $7, $0, $0      # Initialize $7 as global turn counter
        add $6, $23, $0     # Initialize $6 as the prev_switch_map
        addi $19, $0, 1     # Set imm to 0 when not debugging 
        
start:
        nop
        nop
        nop
        nop
        bne $0, $19, debug_start
        nop
        nop
        nop
        nop
        j loop_start
        nop
        nop
        nop
        nop
        
debug_start:
        bne $23, $0 debug_exit
        nop 
        nop 
        nop 
        nop 
        addi $23, $0, 256   # set test bit to be 1 (test 0-256)
        nop 
        nop 
        jal change
        nop 
        nop 
        nop 
        nop 
        addi $23, $0, 257 
        nop 
        nop 
        nop 
        jal change
        nop 
        nop 
        nop 
        addi $23, $0, 769 
        nop 
        nop 
        nop 
        jal change
        nop 
        nop 
        nop 
        addi $22, $0, 1999
        nop 
        nop 
        nop 
        nop 


        bne $23, $0 debug_exit
        nop
        nop
        nop
        nop
        addi $23, $0, 256   # set test bit to be 1 (test 0-256)
        nop 
        nop
        j change
        addi $22, $0, 1999  # Should not be reached


loop_start:                       
                            # Alternate solution to below is to subtract 26 from 6 
                            # and decode the diff into a return reg that tell change
                            # which switch has been flipped.
                            
        bne $23, $6, change # Go to change_loop if $23 has changed
        nop
        nop
        nop
        nop
        j start             # Else spin

change:
	    addi $24, $23, 0	    # Save stage of reg23 in case it changes again
        addi $3, $0, 1      # Set temp reg $3 with mask of 1
        and $17, $7, $3     # Set xo reg ($17) to be 0 or 1 based on turn
                            
                            # Store to $8 0 if empty, 1 if x, 2 if o
                            
                            # Store to $8 the value at $24[0] 
                            # by ANDing $24 with mask of 1 followed by sra 0 

change_8:                            
        addi $3, $0, 1      # Set temp reg $3 with mask of 1
        
        and $4, $24, $3     # Populate temp $4[0] with 0-bit of switch_map 
        sra $5, $4, 0       # Set temp $5 with 0-bit of switch_map
        
        and $4, $6, $3      # Populate temp $4[0] with 0-bit of prev_switch_map
        sra $18, $4, 0      # Set temp $24 with 0-bit of prev_switch_map
        
        bne $5, $18 set_8   # Go to set_8 if 0-bit is the changed bit
        nop
        nop
        nop
        nop
        j change_9          # Else go to change_9

set_8:
        addi, $8, $17, 1    # Set $8 to 1 if x or 2 if o
        j change_end
        
change_9:                            
        addi $3, $0, 2      # Set temp reg $3 with mask of 2
        
        and $4, $24, $3     # Populate temp $4[1] with 1-bit of switch_map 
        sra $5, $4, 1       # Set temp $5 with 1-bit of switch_map
        
        and $4, $6, $3      # Populate temp $4[1] with 1-bit of prev_switch_map
        sra $18, $4, 1      # Set temp $24 with 1-bit of prev_switch_map
        
        bne $5, $18 set_9   # Go to set_9 if 1-bit is the changed bit
        nop
        nop
        nop
        nop
        j change_10         # Else go to change_10

set_9:
        addi, $9, $17, 1    # Set $9 to 1 if x or 2 if o
        j change_end

change_10:                            
        addi $3, $0, 4      # Set temp reg $3 with mask of 4
        
        and $4, $24, $3     # Populate temp $4[2] with 2-bit of switch_map 
        sra $5, $4, 2       # Set temp $5 with 2-bit of switch_map
        
        and $4, $6, $3      # Populate temp $4[2] with 2-bit of prev_switch_map
        sra $18, $4, 2      # Set temp $24 with 2-bit of prev_switch_map
        
        bne $5, $18 set_10  # Go to set_10 if 2-bit is the changed bit
        nop
        nop
        nop
        nop
        j change_11         # Else go to change_11

set_10:
        addi, $10, $17, 1   # Set $10 to 1 if x or 2 if o
        j change_end

change_11:                            
        addi $3, $0, 8 
        
        and $4, $24, $3
        sra $5, $4, 3 
        
        and $4, $6, $3
        sra $18, $4, 3
        
        bne $5, $18 set_11
        nop
        nop
        nop
        nop
        j change_12      

set_11:
        addi, $11, $17, 1
        j change_end

change_12:                            
        addi $3, $0, 16
        
        and $4, $24, $3
        sra $5, $4, 4 
        
        and $4, $6, $3
        sra $18, $4, 4
        
        bne $5, $18 set_12
        nop
        nop
        nop
        nop
        j change_13      

set_12:
        addi, $12, $17, 1 
        j change_end

change_13:                            
        addi $3, $0, 32
        
        and $4, $24, $3
        sra $5, $4, 5 
        
        and $4, $6, $3
        sra $18, $4, 5
        
        bne $5, $18 set_13
        nop
        nop
        nop
        nop
        j change_14      

set_13:
        addi, $13, $17, 1 
        j change_end

change_14:                            
        addi $3, $0, 64
        
        and $4, $24, $3
        sra $5, $4, 6 
        
        and $4, $6, $3
        sra $18, $4, 6
        
        bne $5, $18 set_14 
        nop
        nop
        nop
        nop
        j change_15      

set_14:
        addi, $14, $17, 1 
        j change_end

change_15:                            
        addi $3, $0, 128
        
        and $4, $24, $3
        sra $5, $4, 7
        
        and $4, $6, $3
        sra $18, $4, 7
        
        bne $5, $18 set_15
        nop
        nop
        nop
        nop
        j change_16      

set_15:
        addi, $15, $17, 1 
        j change_end

change_16:                            
        addi $3, $0, 256
        
        and $4, $24, $3
        sra $5, $4, 8 
        
        and $4, $6, $3
        sra $18, $4, 8
        
        bne $5, $18 set_16 
        j change_restart      

set_16:
        addi, $16, $17, 1 
        j change_end

change_restart:                            
        addi $3, $0, 512
        
        and $4, $24, $3
        sra $5, $4, 9 
        
        and $4, $6, $3
        sra $18, $4, 9
        
        bne $5, $18 set_restart 
        j change_end      

set_restart:
        addi $7, $0, 0    # Reset turn counter
	addi $3, $0, 1	  # Temp $3 = 1 for sub insn
	sub $7, $7, $3	  # Subtract to offset change_end addition
	addi $8, $0, 0    # Reset all board regs
	addi $9, $0, 0  
	addi $10, $0, 0  
	addi $11, $0, 0  
	addi $12, $0, 0  
	addi $13, $0, 0  
	addi $14, $0, 0  
	addi $15, $0, 0  
	addi $16, $0, 0  
        j change_end


change_end:
        addi $7, $7, 1      # Increment turn counter
        addi $6, $24, 0     # Set prev_switch_map = switch_map 
        j check_game_over

check_game_over:
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        #j start
	jr $31
        
debug_exit:
        addi $2, $0, 10     # Set $v0 to 10 for exit syscall
	syscall		    # Exit
