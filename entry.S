.section .text
.global __start

__start:
	la sp, stack_top #set stack pointer
	la s11, __save_s11
	la a0, stack_bottom
	sd a0, 16(s11)
	call main.main  #jump to go func main()
# alloc a stack area in .data section
.section .data
.align 4
.global stack_bottom
stack_bottom:
	.space 8192 #stack space
	.global stack_top
stack_top:

.section .data
.global __save_s11
__save_s11:
	.space 16
