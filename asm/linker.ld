OUTPUT_ARCH("riscv")
ENTRY(_start)

SECTIONS
{
    . = 0x0;     /* rv32emu expects code loaded at 0 */
    .text : { *(.text*) }
    . = ALIGN(0x1000);
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) }
}
