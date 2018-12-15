#xor the two 32bit numbers together and if the entire array is 0 then they are 100% the same
.data     
best_matching_score:  .word -1   #best score

best_matching_count:  .word -1   #total number of patterns achieving best score
match:                .word 0xABCDEF00
match1:               .word -5
Pattern_Array:        .word 0, 1, 2, 3, 4, -1, -2, -3, -4, -5, 0xEEEEEEEE, 0x44448888, 0x77777777, 0x33333333, 0xAAAAAAAA, 0xFFFF0000, 0xFFFF, 0xCCCCCCCC, 0x66666666, 0x99999999
Pattern_Array1:       .word 1, -2, 3, -4, 5, -6, 7, -8, 9, -10, -5, 5, -5, 5, -5, 1, -2, 3, -4, 5
.text
la $s0, match
la $s1, Pattern_Array
jal oneHutoo

la $s0, match1
la $s1, Pattern_Array1
jal oneHutoo
oneHutoo:

# $s0 = base address of bitnumone, $s1 = i 
addi $t6, $0, 0
addi $t7, $0, 0 # i = 0 
loop: 
beq $t0, $t7, done # if i ==10, exit loop 
add $t1, $t7, $s0 # $t1 = address of bitnumone[i] 
add $t3, $t7, $s1
lb $t2, 0($t1) # $t2 = bitnumone[i]
lb $t4, 0($t3) # $t4 = bitnumtwo[i] 
xor $t5, $t4, $t2
addi $t7, $t7, 1 # i = i+1
beq $t5, 0, count0       #count the zeros
j loop
count0:
addi $t6, $t6, 1         #this allows us to see how many numbers in bitnum1 are similar to bitnum2
j loop

done:
la $a0, message
li $v0, 4
syscall

move $a0, $t6
li $v0, 1
syscall

la $a0, division
li $v0, 4
syscall

la $a0, 32
li $v0, 1
syscall

la $a0, skip
li $v0, 4
syscall