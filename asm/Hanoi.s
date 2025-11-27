.global  _start
.text
_start:
    jal     ra, setup
    jal     ra, main       # call main
    li      a7, 93         # SYSEXIT
    li      a0, 0
    ecall

setup:
    # li    ra, -1
    li      sp, 0x7ffffff0
    ret

main:
    addi    x2,  x2, -44
    sw      x8,  0(x2)
    sw      x9,  4(x2)
    sw      x18, 8(x2)
    sw      x19, 12(x2)
    sw      x20, 16(x2)
    sw      x0,  20(x2)
    sw      x0,  24(x2)
    sw      x0,  28(x2)
    sw      x21, 32(x2)
    sw      x22, 36(x2)
    sw      ra,  40(x2)

    addi    x8, x0, 1
game_loop:
    # BLANK 4: Check loop termination (2^3 moves)
    addi    x5, x0, 8
    beq     x8, x5, finish_game

    # Gray code formula: gray(n) = n XOR (n >> k)
    # BLANK 5: What is k for Gray code?
    srli    x5, x8, 1

    # BLANK 6: Complete Gray(n) calculation
    xor     x6, x8, x5

    # BLANK 7-8: Calculate previous value and its shift
    addi    x7, x8, -1
    srli    x28, x7, 1

    # BLANK 9: Generate Gray(n-1)
    xor     x7, x7, x28

    # BLANK 10: Which bits changed?
    xor     x5, x6, x7

    # Initialize disk number
    addi    x9, x0, 0

    # BLANK 11: Mask for testing LSB
    andi    x6, x5, 1

    # BLANK 12: Branch if disk 0 moves
    bne     x6, x0, disk_found

    # BLANK 13: Set disk 1
    addi    x9, x0, 1

    # BLANK 14: Test second bit with proper mask
    andi    x6, x5, 2
    bne     x6, x0, disk_found

    # BLANK 15: Last disk number
    addi    x9, x0, 2

disk_found:
    # BLANK 16: Check impossible pattern (multiple bits)
    andi    x30, x5, 5
    addi    x31, x0, 5
    beq     x30, x31, pattern_match
    jal     x0, continue_move
pattern_match:
continue_move:

    # BLANK 17: Word-align disk index (multiply by what?)
    slli    x5, x9, 2

    # BLANK 18: Base offset for disk array
    addi    x5, x5, 20
    add     x5, x2, x5
    lw      x18, 0(x5)

    bne     x9, x0, handle_large

    # BLANK 19: Small disk moves by how many positions?
    addi    x19, x18, 2

    # BLANK 20: Number of pegs
    addi    x6, x0, 3
    blt     x19, x6, display_move
    sub     x19, x19, x6
    jal     x0, display_move

handle_large:
    # BLANK 21: Load reference disk position
    lw      x6, 20(x2)

    # BLANK 22: Sum of all peg indices (0+1+2)
    addi    x19, x0, 3
    sub     x19, x19, x18
    sub     x19, x19, x6

display_move:
    la      x20, obdata
    add     x5, x20, x18

    # BLANK 23: Load byte from obfuscated data
    lbu     x21, 0(x5)

    # BLANK 24: Decode constant (0x6F)
    li      x6, 0x6F
    xor     x21, x21, x6

    # BLANK 25: Final offset adjustment
    addi    x21, x21, -0x12

    add     x7, x20, x19
    lbu     x22, 0(x7)
    xor     x22, x22, x6
    addi    x22, x22, -0x12

    la      x10, str1
    # addi    x17, x0, 4
    # ecall
    jal     ra, print_str

    addi    x10, x9, 1
    # addi    x17, x0, 1
    # ecall
    jal     ra, print_int

    la      x10, str2
    # addi    x17, x0, 4
    # ecall
    jal     ra, print_str

    addi    x10, x21, 0
    # addi    x17, x0, 11
    # ecall
    jal     ra, print_char

    la      x10, str3
    # addi    x17, x0, 4
    # ecall
    jal     ra, print_str

    addi    x10, x22, 0
    # addi    x17, x0, 11
    # ecall
    jal     ra, print_char

    addi    x10, x0, 10
    # addi    x17, x0, 11
    # ecall
    jal     ra, print_char

    # BLANK 26: Calculate storage offset
    slli    x5, x9, 2
    addi    x5, x5, 20
    add     x5, x2, x5

    # BLANK 27: Update disk position
    sw      x19, 0(x5)

    # BLANK 28-29: Increment counter and loop
    addi    x8, x8, 1
    jal     x0, game_loop

finish_game:
    lw      x8, 0(x2)
    lw      x9, 4(x2)
    lw      x18, 8(x2)
    lw      x19, 12(x2)
    lw      x20, 16(x2)
    lw      x21, 32(x2)
    lw      x22, 36(x2)
    lw      ra,  40(x2)
    addi    x2, x2, 44
    # addi    x17, x0, 10
    # ecall
    ret

# Helper functions to adapt to rv32emu
## print_str
print_str:
    addi sp, sp, -4
    sw   ra, 0(sp)

    mv   t4, a0          # t4 = string start
    mv   t5, a0          # t5 = scan pointer
pstr_len_loop:
    lbu  t6, 0(t5)       # read a byte
    beq  t6, x0, pstr_write # stop at 0
    addi t5, t5, 1
    j    pstr_len_loop
pstr_write:
    sub  a2, t5, t4      # a2 = length
    li   a0, 1           # fd = stdout
    mv   a1, t4          # buffer
    li   a7, 64          # syscall write
    ecall

    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

## print_char
print_char:
    addi sp, sp, -8
    sw   ra, 4(sp)
    sb   a0, 0(sp)

    li   a0, 1           # fd = stdout
    mv   a1, sp          # buffer = Stack address
    li   a2, 1           # len = 1 byte
    li   a7, 64          # syscall write
    ecall

    lw   ra, 4(sp)
    addi sp, sp, 8
    ret

## print_int
print_int:
    addi sp, sp, -4
    sw   ra, 0(sp)

    addi a0, a0, 48      # add n with '0' (48) to ASCII code
    jal  ra, print_char

    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

.data
obdata:     .byte   0x3c, 0x3b, 0x3a
str1:       .asciz  "Move Disk "
str2:       .asciz  " from "
str3:       .asciz  " to "
