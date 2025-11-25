.global _start
.section .rodata
str: .ascii "Hello from RV32!\n"
     .set str_size, .-str

.text
_start:
    li a7, 64        # write
    li a0, 1
    la a1, str
    li a2, str_size
    ecall

    li a7, 93
    li a0, 0
    ecall
