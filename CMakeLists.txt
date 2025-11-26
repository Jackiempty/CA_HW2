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

set(ALL_ELF_TARGETS)
set(ALL_BASENAMES)

foreach(ASM_FILE IN LISTS ASM_SOURCES)
    # get file name without file extension
    get_filename_component(BASENAME ${ASM_FILE} NAME_WE)
    list(APPEND ALL_BASENAMES ${BASENAME})

    # ELF target name
    set(ELF_TARGET ${BASENAME}_elf)
    list(APPEND ALL_ELF_TARGETS ${ELF_TARGET})

    # correspond ELF
    add_executable(${ELF_TARGET} ${ASM_FILE})

    # specify linker script
    target_link_options(${ELF_TARGET} PRIVATE
        -nostdlib
        -nostartfiles
        -T${CMAKE_SOURCE_DIR}/asm/linker.ld
    )

    # correspond run target
    add_custom_target(run_${BASENAME}
        COMMAND ${RV32EMU_BIN} ${CMAKE_BINARY_DIR}/${ELF_TARGET}
        DEPENDS rv32emu_build ${ELF_TARGET}
        COMMENT "Running ${ELF_TARGET} under rv32emu..."
    )

    # CTest support
    include(CTest)
    add_test(NAME ${BASENAME}_test
        COMMAND ${RV32EMU_BIN} ${CMAKE_BINARY_DIR}/${ELF_TARGET}
    )
endforeach()

# ---------------------------------------------------------
# Build a run_all target to execute all ELF targets
# ---------------------------------------------------------
add_custom_target(run_all
    COMMENT "Running all ELF programs under rv32emu..."
)

foreach(BASENAME IN LISTS ALL_BASENAMES)
    add_dependencies(run_all run_${BASENAME})
endforeach()