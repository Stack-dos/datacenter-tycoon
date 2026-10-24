.PHONY: all run dependencias configuracion compilacion clean

all: compilacion

dependencias:
	sudo apt update
	sudo apt install build-essential cmake ninja-build git clang-format valgrind -y

configuracion:
	@echo "Configuracion de Compilacion"
	cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug

compilacion: configuracion
	@echo "Compilando ..."
	cmake --build build

run: compilacion
	@echo "Ejecutando ..."
	./build/datacenter_tycoon

clean:
	rm -rf build/