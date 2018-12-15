.data     
best_matching_score:  .word -1   #best score
best_matching_count:  .word -1   #total number of patterns achieving best score
match:                           .word 0xABCDEF00
match1:                         .word -5
Pattern_Array:              .word 0, 1, 2, 3, 4, -1, -2, -3, -4, -5, 0xEEEEEEEE, 0x44448888, 0x77777777, 0x33333333, 0xAAAAAAAA, 0xFFFF0000, 0xFFFF, 0xCCCCCCCC, 0x66666666, 0x99999999
Pattern_Array1:             .word 1, -2, 3, -4, 5, -6, 7, -8, 9, -10, -5, 5, -5, 5, -5, 1, -2, 3, -4, 5
mymatch:                      .word 0x18BC
myarr:                            .word 0, 2, 3, 55, 0xAA, 19, 0XFFCCAABB, 19
.text
add $t0, $t0, $0        #counter for zeroes
add $t1, $0, $0        #counter for best matching zeroes
addi $t7, $0, 0x205C
addi $s0, $0, 0x2008           #$s0 will be compared to by $s1
addi $s1, $s0, 8
j main

next:
addi $s0, $0, 0x200C         #$s0 will be compared to by $s1
addi $s1, $0, 0x2060
addi $t7, $0, 0x20AC
sw $0, ($t6)                        #reset values in best score and best total numbers
sw $0, ($t4)
j main

mystuff:
addi $s0, $0, 0x20B0
addi $s1, $0, 0x20B4
addi $t7, $0, 0x20D0
sw  $0, ($t6)
sw  $0, ($t4)
j main

main:
lw $s3, ($s0)              #load match
lw $t3, 0($s1)            #load pattern array
addi $s1, $s1, 4        #move in pattern array
xor $t4, $s3, $t3         #xor the two values together to find exact same bits
j count0                  #begin counting zeroes
cont:
slt $t5, $s1, $t7         #will stop this loop if we reach the end of $s1 aka pattern array
beq $t5, $0, out
j main                        #loop again until we've gone through entire pattern array
out:
beq $s0, 0x200C, mystuff
beq $s0, 0x20B0, end
j next

count0:
addi $t5, $0, 1		#$t5 =1
and $t5, $t4, $t5            #$t5 and with lsb in $t4
bne $t5, $0, loopcount     #if current xored value is not zero loop again
slti $t3, $s2, 32           #check to see if $t4 has counted all xored values
beq $t3, $0, bigone    #branch to compare
addi $t0, $t0, 1           #add 1 to 0 counter for zeroes
loopcount:
addi $s2, $s2, 1         #count number of bits already scanned
srl $t4, $t4, 1              #shift in xoredvalue
j count0                      #loop


bigone:
add $s2, $0, $0             #reset bit counter for 32 bits
addi $t6, $0, 0x2000     #open memory of best matching score
lw $t2, ($t6)                                 #load score $t2 for comparison
beq $t0, $t2, add1                       #if it equals current score we will add one to best matching count
slt $t5, $t0, $t2                            #count should be less than count from previous count from register load
beq $t5, $0, reset                        #if not, then reset by saving new register count in best matching score
add1:
bne $t0, $t2, edit                      
addi $t1, $t1, 1                             #increase counter for 0's
addi $s4, $0, 0x2004
sw $t1, ($s4)                               #save counter
add $t0, $0, $0                            #reset counter
add $t2, $t2, $0
why:
j cont

reset:
sw $t0, ($t6)
add $t1, $0, $0                          #also reset the best matching score count
addi $t1, $0, 1                           #add one to the best matching score count immediately
sw $t1, ($s4)
add $t0, $0, $0
j cont

edit:
add $t0, $0, $0
j cont
end: