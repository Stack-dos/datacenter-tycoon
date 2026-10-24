.PHONY: all run dependencias configuracion compilacion test test-asan valgrind clean

all: compilacion

dependencias:
	sudo apt update
	sudo apt install build-essential cmake ninja-build git clang-format valgrind -y
	sudo apt install libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \
		libgl1-mesa-dev libasound2-dev libwayland-dev libxkbcommon-dev -y

configuracion:
	@echo "Configuracion de Compilacion"
	cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug

compilacion: configuracion
	@echo "Compilando ..."
	cmake --build build

run: compilacion
	@echo "Ejecutando ..."
	./build/datacenter_tycoon

test: compilacion
	ctest --test-dir build --output-on-failure

# Build aparte para no pisar build/ (ASan + UBSan solo en los tests)
test-asan:
	cmake -B build-asan -G Ninja -DCMAKE_BUILD_TYPE=Debug -DDCT_SANITIZE=ON
	cmake --build build-asan
	ctest --test-dir build-asan --output-on-failure

valgrind:
	bash scripts/valgrind.sh

clean:
	rm -rf build/ build-asan/
