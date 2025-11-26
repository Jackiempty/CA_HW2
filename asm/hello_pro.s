.global _start
.section .rodata
str: .ascii "Hello Pro from RV32!\n"
     .set str_size, .-str

.text
_start:
    jal ra, main
    li a7, 93
    li a0, 0
    ecall

main:
    addi sp, sp, -4
    sw   ra, 0(sp)
    jal  ra, print
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

print:
    addi sp, sp, -4
    sw   ra, 0(sp)

    li a7, 64        # write
    li a0, 1
    la a1, str
    li a2, str_size
    ecall
    
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret
