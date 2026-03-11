.global _start
.intel_syntax noprefix

_start:
$echo "Hello, World!"
	mov rax, 60
	mov rdi, 0
	syscall

