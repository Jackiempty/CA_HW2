BUILD_DIR = build
BUILD_TYPE := Debug

.PHONY: all format clean

all:
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake .. -GNinja -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
	cd $(BUILD_DIR) && cmake --build .
# 	@-mv $(BUILD_DIR)/compile_commands.json .

format:
	find . -name build -type d \! -prune -o -iname '*.h' -o -iname '*.cpp' | xargs clang-format -i

clean:
	rm -rf $(BUILD_DIR)
