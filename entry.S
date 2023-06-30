.section .text
.global __start

__start:
	la sp, stack_high #set stack pointer
	la s11, stack_guard
	la a0, stack_low
	sd a0, 16(s11)
	call main.main  #jump to go func main()
# alloc a stack area in .data section
.section .data
.align 4
.global stack_low
stack_low:
	.space 8192 #stack space
	.global stack_high
stack_high:

.section .data
.global stack_guard
stack_guard:
	.space 16
