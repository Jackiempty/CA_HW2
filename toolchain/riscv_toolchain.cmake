set(CMAKE_SYSTEM_NAME Generic)

set(RISCV_PREFIX riscv-none-elf-)

set(CMAKE_C_COMPILER   ${RISCV_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${RISCV_PREFIX}g++)
set(CMAKE_ASM_COMPILER ${RISCV_PREFIX}gcc)

set(CMAKE_OBJCOPY ${RISCV_PREFIX}objcopy)
set(CMAKE_OBJDUMP ${RISCV_PREFIX}objdump)

# RV32I target
set(CMAKE_C_FLAGS "-march=rv32i -mabi=ilp32")
set(CMAKE_ASM_FLAGS "-march=rv32i -mabi=ilp32")
