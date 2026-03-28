set(CMAKE_SYSTEM_NAME               Generic)
set(CMAKE_SYSTEM_PROCESSOR          arm)

set(TOOLCHAIN_PATH "/opt/arm-gcc/bin/")
set(TOOLCHAIN_PREFIX   arm-none-eabi-)

set(CMAKE_C_COMPILER       "${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}gcc" CACHE FILEPATH "C compiler" FORCE)
set(CMAKE_CXX_COMPILER     "${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}g++" CACHE FILEPATH "C++ compiler" FORCE)
set(CMAKE_ASM_COMPILER     "${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}gcc" CACHE FILEPATH "ASM compiler" FORCE)
set(CMAKE_OBJCOPY          "${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}objcopy" CACHE FILEPATH "objcopy" FORCE)
set(CMAKE_SIZE             "${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}size" CACHE FILEPATH "size" FORCE)

# Mantemos APENAS as flags que são universais para qualquer projeto embarcado C/C++
set(COMMON_FLAGS       "-fdata-sections -ffunction-sections")
set(CPP_FLAGS          "-fno-rtti -fno-exceptions -fno-threadsafe-statics")

set(CMAKE_C_FLAGS          "${COMMON_FLAGS}" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_CXX_FLAGS        "${COMMON_FLAGS} ${CPP_FLAGS}" CACHE STRING "C++ compiler flags" FORCE)
set(CMAKE_ASM_FLAGS        "${COMMON_FLAGS}" CACHE STRING "ASM compiler flags" FORCE)

# Evita que o CMake tente compilar um executável de teste para o SO host
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)