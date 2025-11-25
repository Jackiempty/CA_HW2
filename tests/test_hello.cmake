include(CTest)

add_test(NAME run_hello_test
    COMMAND ${RV32EMU_BIN} ${CMAKE_BINARY_DIR}/hello_elf
)
