cmake_minimum_required(VERSION 3.29) # Version de CMake
project(Datacenter_Tycoon LANGUAGES C)

set(CMAKE_C_STANDARD 11) # Version de C

# Obliga a que CMake falle si el compilador no soporta dicha versión
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Apagamos opciones de Raylib que no necesitamos para que compile más rápido
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

# Añadimos la carpeta del submódulo
add_subdirectory(lib/raylib)

add_library(raygui STATIC src/ui/raygui_impl.c)
target_include_directories(raygui PUBLIC lib/raygui/src)
target_link_libraries(raygui PUBLIC raylib)

add_library(cjson STATIC lib/cjson/cJSON.c)
target_include_directories(cjson PUBLIC lib/cjson)


# Genera ejecutables a partir de codigo fuente
add_executable(datacenter_tycoon src/main.c)

target_compile_options(datacenter_tycoon PRIVATE 
    -Wall 
    -Wextra 
    -Werror
    -Wpedantic
)

# Linkear Raylib
target_link_libraries(datacenter_tycoon PRIVATE raylib)
target_link_libraries(datacenter_tycoon PUBLIC raygui)