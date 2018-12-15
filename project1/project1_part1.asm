.data
my_array: .word -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, 18, -19, -20, -21, -22, -23, -24  #this is to store the values of 6^p and mod 17 of 6^p

.text
main:
addi $t1, $0, 1020     #multiple to be used for mod 17
addi $t6, $t6, 0 #counter
addi $t2, $0, 1        #small variable to be added repeatedly
addi $t0, $0, 0x2018   #power will be 5, 8 11 and jump to a function to perform a nested loop
addi $t5, $0, 0x2000
jal dapowa

addi $t0, $0, 0x201C   #setting up addresses for modulation
addi $t5, $0, 0x2018
add $t2, $0, $0
add $t6, $0, $0
jal mods

addi $t2, $0, 1
addi $t0, $0, 0x203C   
addi $t5, $0, 0x2018
jal dapowa

addi $t0, $0, 0x2040
addi $t5, $0, 0x203C
add $t2, $0, $0
jal mods

addi $t2, $0, 1
addi $t0, $0, 0x206C   
addi $t5, $0, 0x203C
jal dapowa

addi $t0, $0, 0x2070
addi $t5, $0, 0x206C
add $t2, $0, $0
jal mods

j end

dapowa:  #this applies the power to 6
sw $t4, ($t5)         #save $t4 into $s0
addi $t5, $t5, 4
slt $t3, $t5, $t0     #save address is less than the limiting address for the power
beq $t3, $0, donebruhh
add $t4, $t2, $t2     # 1--->2    6--->12
add $t2, $t4, $t2     # 2--->3    12-->18
add $t4, $t2, $t2     # 3--->6    18-->36    6^3    6^4     6^5.....     6^11
add $t2, $0, $t4      #After trial and error it was easier to save $t4 meanwhile swapping it with $t2
                      #before looping again
j dapowa
donebruhh:
jr $ra

mods:    # here we take care of the modulo part of program
slt $t3, $t2, $t4           #$t2 < $t4  
beq $t3, $0, sub17     #when $t4 is greater than $t2
add $t2, $t2, $t1         #add 1020 (a num divisible by 17) over and over again
addi $t6, $t6, 1          #if this method takes too long we will 2x1020 then 3x1020...so on and so forth
beq $t6, 50, mul1020#jump to perform the above comment
j mods                       #repeat loop until this number is just above 6^power
sub17:
slt $t3, $t4, $t2          #6^p is less than the number divisible by 17
beq $t3, $0, done
subi $t2, $t2, 17       #keep subtracting 17 until we are under 6^p
j sub17
done:
sub $t4, $t4, $t2     #subtract 6^p by $t2 which gives us 6^p mod17
sw $t4, ($t5)
jr $ra 

mul1020:
addi $t1, $t1, 1020  #double the number divisible by 17
add $t6, $0, $0       #reset counter that tells you when the adding of $t2 is taking too long
j mods


end: