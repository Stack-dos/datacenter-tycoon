# dct_enable_sanitizers(<target>): ASan + UBSan si DCT_SANITIZE=ON
function(dct_enable_sanitizers target)
    if(DCT_SANITIZE)
        set(flags -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all)
        target_compile_options(${target} PRIVATE ${flags})
        target_link_options(${target} PRIVATE ${flags})
    endif()
endfunction()
