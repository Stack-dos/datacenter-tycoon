cmake_minimum_required(VERSION 3.29) # Version de CMake
project(Datacenter_Tycoon LANGUAGES C)

set(CMAKE_C_STANDARD 11) # Version de C

# Obliga a que CMake falle si el compilador no soporta dicha versión
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Genera ejecutables a partir de codigo fuente
add_executable(datacenter_tycoon src/main.c)

target_compile_options(datacenter_tycoon PRIVATE 
    -Wall 
    -Wextra 
    -Werror
    -Wpedantic
)