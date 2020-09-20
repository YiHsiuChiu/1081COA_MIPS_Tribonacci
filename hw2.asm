main:
la $a0, input_msg
li $v0 4                       # System call: print "Input number "
syscall 
li $v0 5                       # System call: get the user input and save in $v0
syscall 
addi $s7,$v0,0			#n=s7

#leaf n!
addi $t0,$s7,0			#t0=n
addi $s0,$zero,0		#sum=s0
loop1:
slt $t1,$zero,$t0		#if(0<n) t1=1
beq $t1,$zero,Exit1
add $s0,$s0,$t0			#s0+=t0
addi $t0,$t0,-1
j loop1

Exit1:
la $a0, output_msg1
li $v0 4                       
syscall 
move $a0, $s0
li $v0 1                       
syscall 


#leaf Tribonacci number
addi $t0,$s7,0			#t0=n
addi $t1,$zero,2		#t1=count
addi $s0,$zero,0
addi $s2,$zero,0
beq $t0,$s0,Exit2		#if(n==0) print 0
addi $s1,$zero,1
addi $s2,$zero,1	
beq $t0,$s1,Exit2		#if(n==1) print 1
beq $t0,$s2,Exit2		#if(n==2) print 1

loop2:
beq $t1,$t0,Exit2		#if(n==count) goto exit
add $t2,$s0,$s1			
add $t2,$t2,$s2			#t2=T(count) + T(count-1) + T(count-2)

addi $s0,$s1,0
addi $s1,$s2,0
addi $s2,$t2,0	
addi $t1,$t1,1			#count++,and set T()
j loop2

Exit2:
la $a0, output_msg2
li $v0 4                       
syscall 
move $a0, $s2
li $v0 1                       
syscall 


# non-leaf n!
move $a0, $s7
jal recursive1
addi $s0,$v0,0

la $a0, output_msg3
li $v0 4                       
syscall 
move $a0, $s0
li $v0 1                       
syscall 


#non-leaf Tribonacci number
move $a0, $s7
jal recursive2
move $s0, $v0

la $a0, output_msg4
li $v0 4                       
syscall 
move $a0, $s0
li $v0 1                       
syscall 


End:
li $v0, 10                     # System call: exit
syscall

recursive1:
addi $sp, $sp, -8 		# adjust stack for 2 items
sw $ra, 4($sp) 			# save return address
sw $a0, 0($sp) 			# save argument (n)
slti $t0, $a0, 1 		# test for n < 1
beq $t0, $zero, else1		# jump to ELSE if n >=1
addi $v0, $zero, 0 		# if not, result is 0
addi $sp, $sp, 8 		# clean stack frame
jr $ra 				# return
else1: 
addi $a0, $a0, -1 		# else decrement n by 1 
jal recursive1			# recursive call 
lw $a0, 0($sp) 			# restore original n
lw $ra, 4($sp) 			# restore return address
addi $sp, $sp, 8 		# clean stack frame
add $v0, $a0, $v0 		# += to get result
jr $ra 				# and return

recursive2: 
addi $sp, $sp, -16
sw $ra, 12($sp)
sw $s0, 8($sp)			#store a0
sw $s1, 4($sp)			#store T(n-1)
sw $s2, 0($sp)			#store T(n-2)
move $s0, $a0
beq $s0,$zero,is0		#if T(0) return 0
li $v0, 1			# return 1
j continue 
is0:
li $v0, 0			#return 0
continue: 			
ble $s0, 0x2, else2	 	# if<3 go else2
addi $a0, $s0, -1 		# set args for recursive call to f(n-1)
jal recursive2
move $s1, $v0 			# store result of f(n-1) to s1
addi $a0, $s0, -2 		# set args for recursive call to f(n-2)
jal recursive2
move $s2, $v0 			# store result of f(n-2) to s2
addi $a0, $s0, -3 		# set args for recursive call to f(n-3)
jal recursive2
add $v0, $s1, $v0
add $v0, $s2, $v0		# add result of f(n-1)&f(n-2) to it
else2:
lw $ra, 12($sp)
lw $s0, 8($sp)
lw $s1, 4($sp)
lw $s2, 0($sp)
addi $sp, $sp, 16
jr $ra


.data 
input_msg: .asciiz "Input: "
output_msg1: .asciiz "leaf n! result: "
output_msg2: .asciiz "\nleaf Tribonacci number: "
output_msg3: .asciiz "\nnon-leaf n! result: "
output_msg4: .asciiz "\nnon-leaf Tribonacci number: "
