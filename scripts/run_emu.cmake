message(STATUS "Running program under rv32emu: ${ARGV0}")
execute_process(
    COMMAND ${RV32EMU_BIN} ${ARGV0}
)
