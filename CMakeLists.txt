cmake_minimum_required(VERSION 3.20)

# ---------------------------------------------------------
# RISC-V Toolchain
# ---------------------------------------------------------
set(RISCV_PREFIX riscv-none-elf-)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_COMPILER   ${RISCV_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${RISCV_PREFIX}g++)
set(CMAKE_ASM_COMPILER ${RISCV_PREFIX}gcc)

set(CMAKE_OBJCOPY ${RISCV_PREFIX}objcopy)
set(CMAKE_OBJDUMP ${RISCV_PREFIX}objdump)

set(CMAKE_C_FLAGS "-march=rv32i -mabi=ilp32")
set(CMAKE_ASM_FLAGS "-march=rv32i -mabi=ilp32")

project(ca_hw2 C CXX ASM)

# ---------------------------------------------------------
# Build rv32emu
# ---------------------------------------------------------
set(RV32EMU_DIR ${CMAKE_SOURCE_DIR}/rv32emu)
add_custom_target(rv32emu_build ALL
    COMMAND make
    WORKING_DIRECTORY ${RV32EMU_DIR}
    COMMENT "Building rv32emu..."
)
set(RV32EMU_BIN ${RV32EMU_DIR}/build/rv32emu)

# ---------------------------------------------------------
# Build all assembly files in asm/*.s or *.S
# ---------------------------------------------------------
file(GLOB ASM_SOURCES "${CMAKE_SOURCE_DIR}/asm/*.s" "${CMAKE_SOURCE_DIR}/asm/*.S")

add_executable(hello_elf ${ASM_SOURCES})

target_link_options(hello_elf PRIVATE
    -nostdlib
    -nostartfiles
    -T${CMAKE_SOURCE_DIR}/asm/linker.ld
)

# ---------------------------------------------------------
# Add simple run target
# ---------------------------------------------------------
add_custom_target(run
    COMMAND ${RV32EMU_BIN} ${CMAKE_BINARY_DIR}/hello_elf
    DEPENDS rv32emu_build hello_elf
    COMMENT "Running program under rv32emu..."
)

# ---------------------------------------------------------
# Optional: CTest support
# ---------------------------------------------------------
include(CTest)
add_test(NAME hello_test
    COMMAND ${RV32EMU_BIN} ${CMAKE_BINARY_DIR}/hello_elf
)
