include(${PROJECT_SOURCE_DIR}/cmake/sanitizers.cmake)

# Unity sin warnings estrictos (es código de lib/)
add_library(unity STATIC ${PROJECT_SOURCE_DIR}/lib/unity/src/unity.c)
target_include_directories(unity PUBLIC ${PROJECT_SOURCE_DIR}/lib/unity/src)
target_compile_definitions(unity PUBLIC UNITY_INCLUDE_DOUBLE)
dct_enable_sanitizers(unity)

# dct_add_test(<nombre>): tests/unit/<nombre>.c -> ejecutable + add_test
function(dct_add_test name)
    add_executable(${name} unit/${name}.c)
    target_compile_options(${name} PRIVATE -Wall -Wextra -Werror -Wpedantic)
    target_link_libraries(${name} PRIVATE unity)
    dct_enable_sanitizers(${name})
    add_test(NAME ${name} COMMAND ${name})
endfunction()

dct_add_test(test_sanity)
