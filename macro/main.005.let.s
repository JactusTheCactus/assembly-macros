.global _start
.intel_syntax noprefix

_start:

	mov rax, 1
	mov rdi, 1
	lea rsi, [rip + hello_world_0]
	mov rdx, 14
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

.section .rodata

hello_world_0:
	.asciz "Hello, World!\n"
