# This is a set of examples in a series of using x86 (32bit) and x86_64 (64bit) assembly
# instructions. Assemble and link these files and trace through the executable with the
# debugger. The idea is to get a sense of how to use these instructions, so you can rip
# this and use it in your own code
#
# If you have any questions, comments, concerns, or find bugs, then just send me an email.
# 
# - richard.m.veras@ou.edu

.section .data
# This example does not make use of the data section	
.section .text
# The .text section is our executable code.

# We need to make the symbol _start available to the loader (ld) and we do this
# with .globl	
.globl _start
_start:
	# The stack is a segment (.section)  in memory allocated to our program, by the OS
	# We can see where the top of the stack is by reading the stack pointe %rsp (%esp in
	# 32 bit mode). And we can add or remove 8 Byte wide words from the stack using the
	# push and pop instruction, respectively. This is one of the situations where there
	# is a bit of a difference between using 32bit instructions versus 64bit instruction
	# when executing on a 64 bit machine. The issue is we have to use the quad word versions
	# of push and pop, and we cannot mix modes like we can with the math instructions.
	# This means for the most part we are only dealing with the 64bit registers rXX (rax,rbx
	# rcx,...r8,...,r15) with push and pop
	
	# TEST: In gdb examine the memory before and after the following instructions.
	#       (gdb) x/4gx &data_items_quad_8B

	# We can examine the top of the stack by looking at the value at %rsp
	movq (%rsp), %rax

	# If we want to peak at the value right below the top we can do the following:
	movq 8(%rsp), %rbx

	
	# Pushing and popping to the stack with push and pop
	# pushing without push
	movq $0xC0A1E5CE55EAF00D, %rax
	subq $8, %rsp
	movq %rax, (%rsp)

	# popping without pop
	movq (%rsp), %rax
	addq $8, %rsp
	
	# pushing and popping using the equivalent instructions
	# Note: this is this exact same thing that push and pop
	#       do, but with way more instructions.
	
	
	# push some values
	movq $0xAAAAAAAAAAAAAAAA, %rax
	movq $0XBBBBBBBBBBBBBBBB, %rbx
	movq $0xCCCCCCCCCCCCCCCC, %rcx
	movq $0xDDDDDDDDDDDDDDDD, %rdx

	# Note: Watch how %rsp decreases by 8B each time we push a value
	#       because we are moving the top of the stack. The stack starts
	#       at a really large address and decreases to 0x0000000000000000 (the top)
	#       as it moves up.
	# TEST: look at %rsp in gdb
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdx


	# pop the values off the stack
	# Note: every time we pop a value %rsp increases by 8B
	# if we did it right then we should have flipped the values around.
	# TEST: check the registers in gdb
	popq %rax
	popq %rbx
	popq %rcx
	popq %rdx	
	
	jmp _exit_x86_64bit

_exit_x86_64bit:
	# This is slightly different because in x86_64 (64bit) we get the
	# syscall instruction, which provides more flexibility than int (interrupt)
	# so it is the defacto way for making system calls in 64bit binaries, in linux,
	# on systems with the x86_64 instruction set architecture.
	movq $60, %rax  # call number 60 -> exit
	movq $0x0, %rdi # return 0
	syscall #run kernel
	
	
