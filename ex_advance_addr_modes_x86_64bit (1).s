# This is a set of examples in a series of using x86 (32bit) and x86_64 (64bit) assembly
# instructions. Assemble and link these files and trace through the executable with the
# debugger. The idea is to get a sense of how to use these instructions, so you can rip
# this and use it in your own code
#
# If you have any questions, comments, concerns, or find bugs, then just send me an email.
# 
# - richard.m.veras@ou.edu

.section .data

data_items_long_4B:
	.long 0xAAAAAAAA, 0xBBBBBBBB, 0xCCCCCCCC, 0xDDDDDDDD


	
data_items_quad_8B:
	.quad 0xEEEEEEEEEEEEEEEE, 0xFFFFFFFFFFFFFFFF
	

list_of_64_bit_addresses:
	.quad data_items_long_4B, data_items_quad_8B
	
	
.section .text
# The .text section is our executable code.

# We need to make the symbol _start available to the loader (ld) and we do this
# with .globl	
.globl _start
_start:

#########################
# Moving 4 Byte .long   #
# with 64 bit addresses #
#########################

	#######################
	# Direct address mode #
	#######################
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4wx &data_items_long_4B



	# Reading data #
	# movl immaddr, reg --> reg = Mem[immaddr]
	# NOTE: for immediate addresses we do not prefix with a "$"
	#       like we would for immediate values
	movl data_items_long_4B, %eax

	# Writing data #
	# movl reg, immaddr --> Mem[immaddr] = reg
	movl $0xBA53BA11, %eax
	movl %eax, data_items_long_4B


	########################
	# Indexed address mode #
	########################
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4wx &data_items_long_4B

	# reading using indexed
	# movl immaddr(,rega,immstride), regb --> regb = Mem[immaddr+rega*immstride]
	movl $1, %edi
	movl data_items_long_4B(,%edi,4), %ebx

	# writing using the indexed address mode
	movl $0xBADDECAF, %edx
	movl $1, %edi
	movl %edx, data_items_long_4B(,%edi,4)
	
	#########################
	# Indirect address mode #
	#########################
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4wx &data_items_long_4B
	# movl (rega), regb --> regb = Mem[rega]
	# movl rega, (regb) --> Mem[regb] = rega

	# NOTE: Here is where we need to be careful with the whole 32bit and 64bit
	#       addresses. When we are storing addresses for 64bit applications, we
	#       need to use the quad word sized rXX registers. The reason being is
	#       suppose the location of data_items_long_4B is: 0x0000000050F7BA11 if
	#       we store that value using 32bit registers (eXX) it would get truncated to
	#       0x50F7BA11, no problem it is still the same value.
	#
	#       However if the address to data_items_long_4B was 0xFEEDCA755AFE70AD and
	#       we try to store that 64bit address in a 32bit register (eax,ebx,ecx,...)
	#       then that address would be truncated (provided the assembler does not
	#       throw and error) to just 0x5AFE70AD.
	#
	#       So we are going to play it safe and only store addresses in 64bit registers
	#       (rax,rbx,rcx,...)

	
	# NOTE: that we are prefixing data_items_long_4B with a "$", this is because
	#       we want to throw the value of the address in %ebx, and not the actual
	#       data that is located at that address.
	movq $data_items_long_4B, %rbx
	movl (%rbx), %edx

	movl $0xF007BA11, %ecx
	movq $data_items_long_4B, %rax
	movl %ecx, (%rax)

	# Here is a weird one
	# Note how there is not a "$" in front of that location
	# something slightly different is happening here.
	movl $0xF005BA11, %ecx
	movq list_of_64_bit_addresses, %rax
	movl %ecx, (%rax)

	
	#####################
	# Base Pointer Mode #
	#####################
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4wx &data_items_long_4B
	# movl imm (rega), regb --> regb = Mem[rega+imm]
	movq $data_items_long_4B, %rax
	movl 4(%rax), %ebx


	movq $data_items_long_4B, %rsi
	movl $0x707A11ED, %eax
	movl %eax, 8(%rsi) 
	
	
	#########################
	# Moving 8 Byte .quad   #
	# with 64 bit addresses #
	#########################
	# we can do all of the same stuff as before, but on 8Byte, quad word length data.

	#############
	# immediate #
	#############
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4gx &data_items_quad_8B

	movq data_items_quad_8B, %rax

	# Writing data #
	# movl reg, immaddr --> Mem[immaddr] = reg
	movq $0xA111BA53510ADDED, %rax
	movq %rax, data_items_quad_8B


	###########
	# Indexed #
	###########
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4gx &data_items_quad_8B
	# reading using indexed
	# movl immaddr(,rega,immstride), regb --> regb = Mem[immaddr+rega*immstride]
	movq $1, %rdi
	movq data_items_quad_8B(,%rdi,8), %rbx

	# writing using the indexed address mode
	movq $0x5ADDE57BADDECAF, %rdx
	movq $1, %rdi
	movq %rdx, data_items_quad_8B(,%rdi,8)

	############
	# Indirect #
	############
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4gx &data_items_quad_8B
	movq $data_items_quad_8B, %rbx
	movq (%rbx), %rdx


	movq $0xDE7E57AB13D00D1E, %rcx
	movq $data_items_quad_8B, %rax
	movq %rcx, (%rax)


	#####################
	# Base Pointer Mode #
	#####################
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4gx &data_items_quad_8B
	# movl imm (rega), regb --> regb = Mem[rega+imm]
	movq $data_items_quad_8B, %rax
	movq 8(%rax), %rbx


	movq $data_items_quad_8B, %rsi
	movq $0xF1A7B0A7707A11ED, %rax
	movq %rax, 8(%rsi) 

	
	#################################
	# Safely exit in x86_64 (64bit) #
	#################################
	jmp _exit_x86_64bit

_exit_x86_64bit:
	# This is slightly different because in x86_64 (64bit) we get the
	# syscall instruction, which provides more flexibility than int (interrupt)
	# so it is the defacto way for making system calls in 64bit binaries, in linux,
	# on systems with the x86_64 instruction set architecture.
	movq $60, %rax  # call number 60 -> exit
	movq $0x0, %rdi # return 0
	syscall #run kernel
	
	
