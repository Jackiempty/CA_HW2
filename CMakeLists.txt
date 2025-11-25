cmake_minimum_required(VERSION 3.20)
project(ca_hw2 C CXX ASM)

# ---------------------------------------------------------
# Add submodule path (rv32emu does NOT use CMake)
# ---------------------------------------------------------
set(RV32EMU_DIR ${CMAKE_SOURCE_DIR}/rv32emu)

# Build rv32emu using its Makefile
add_custom_target(rv32emu_build ALL
    COMMAND make
    WORKING_DIRECTORY ${RV32EMU_DIR}
    COMMENT "Building rv32emu using its Makefile"
)

# Path to generated emulator binary
set(RV32EMU_BIN ${RV32EMU_DIR}/build/rv32emu)

# ---------------------------------------------------------
# RISC-V Toolchain
# ---------------------------------------------------------
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/toolchain/riscv_toolchain.cmake)

# ---------------------------------------------------------
# Build sample assembly
# ---------------------------------------------------------
add_executable(hello_elf asm/hello.S)


# Custom target: run on rv32emu
add_custom_target(run_hello
    COMMAND ${RV32EMU_BIN} hello_elf
    DEPENDS rv32emu_build hello_elf
    COMMENT "Running hello_elf with rv32emu..."
)

target_link_options(hello_elf PRIVATE
    -nostdlib
    -nostartfiles
    -T${CMAKE_SOURCE_DIR}/asm/linker.ld
)

# ---------------------------------------------------------
# Optionally include tests
# ---------------------------------------------------------
include(tests/test_hello.cmake)
