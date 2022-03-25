.section .data
fizz:
	.ascii "FIZZ\n"
buzz:
	.ascii "BUZZ\n" 
fizzbuzz:
	.ascii "FIZZBUZZ\n"
stop:
	.long 1001
counter:
	.long 1
three_count:
	.long 1
five_count:
	.long 1
number:
	.long 0,0,0,0,0,0,0,0,0,0,-1
new_line:
	.ascii "\n"
.section .text
.globl _start

_start:
movl $0, %eax 
start_loop: # start loop
movl $0, %eax
movl stop(,%eax,4), %edi
movl counter(,%eax,4), %esi
cmpl counter(,%eax,4), %edi # check to see if we’ve hit the end
je loop_exit
cmpl $3, three_count(,%eax,4)
je reset_three
cmpl $5, five_count(,%eax,4)
je reset_five
addl $1, five_count(,%eax,4)
addl $1, three_count(,%eax,4)
movl counter(,%eax,4), %eax
movl $9, %ebx
jmp convert_num

reset_three:
cmpl $5, five_count(,%eax,4)
je print_fizzbuzz
movl $1, %eax
movl $1, %edi
movl $fizz, %esi
movl $5, %edx
syscall
movl $0, %eax
addl $1, five_count(,%eax,4)
addl $1, counter(,%eax,4)
movl $1, three_count(,%eax,4)
jmp start_loop

reset_five:
movl $1, %eax
movl $1, %edi
movl $buzz, %esi
movl $5, %edx
syscall
movl $0, %eax
movl $1, five_count(,%eax,4)
addl $1, three_count(,%eax,4)
addl $1, counter(,%eax,4)
jmp start_loop

print_fizzbuzz:
movl $1, %eax
movl $1, %edi
movl $fizzbuzz, %esi
movl $9, %edx
syscall
movl $0, %eax
movl $1, three_count(,%eax,4)
movl $1, five_count(,%eax,4)
addl $1, counter(,%eax,4)
jmp start_loop

convert_num:
movl $0, %edx
movl $10, %edi
divl %edi
addl $48, %edx
movl %edx, number(,%ebx,4)
cmpl $0, %eax
je set_index
decl %ebx
jmp convert_num

set_index:
movl $-1, %ebx
movl $number-5, %esi
jmp print_loop

print_loop:
incl %ebx
addl $4, %esi 
cmpl $-1, number(,%ebx,4)
je print_newline
cmpl $0, number(,%ebx,4)
je print_loop
movl $1, %eax
movl $1, %edi
movl $4, %edx
syscall
jmp print_loop

print_newline:
movl $1, %eax
movl $1, %edi
movl $new_line, %esi
movl $1, %edx
syscall
movl $0, %eax
addl $1, counter(,%eax,4)
jmp start_loop

loop_exit:
movl $1, %eax #1 is the exit() syscall
int $0x80
