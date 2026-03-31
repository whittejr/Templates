cmake_minimum_required(VERSION 3.22)
project(${TARGET_MCU} C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(EXECUTABLE "firmware")

# ==============================================================================
# 1. INJEÇÃO DE HARDWARE
# ==============================================================================
if(NOT DEFINED MCU_FAMILY)
    message(FATAL_ERROR "MCU_FAMILY não definida!")
endif()

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/mcu/${MCU_FAMILY}.cmake")

# 🚨 AS ARMADILHAS DE DEBUG 🚨
# Se as variáveis estiverem vazias, o CMake vai abortar e te avisar o porquê!
if("${LINKER_SCRIPT}" STREQUAL "")
    message(FATAL_ERROR "ERRO: A variável LINKER_SCRIPT está vazia! Verifique o seu arquivo stm32wb.cmake.")
endif()

if("${HAL_SOURCES}" STREQUAL "")
    message(FATAL_ERROR "ERRO: A variável HAL_SOURCES está vazia! A HAL não será compilada.")
endif()

# ==============================================================================
# 2. AUTO-DISCOVERY (O Radar com as suas pastas)
# ==============================================================================
file(GLOB_RECURSE APP_SOURCES CONFIGURE_DEPENDS
    "core/src/*.c"
    "lib/BSP/src/*.c"
    "lib/components/*.c"
)

file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS 
    "core/inc/*.h" 
    "lib/BSP/inc/*.h" 
    "lib/components/*.h"
)

set(APP_INCLUDES "")
foreach(HEADER ${HEADER_FILES})
    get_filename_component(HEADER_DIR ${HEADER} DIRECTORY)
    list(APPEND APP_INCLUDES ${HEADER_DIR})
endforeach()

if(APP_INCLUDES)
    list(REMOVE_DUPLICATES APP_INCLUDES)
endif()

# ==============================================================================
# 3. CRIAÇÃO DO EXECUTÁVEL E INCLUDES
# ==============================================================================
# Se a armadilha não disparar, o executável vai receber a HAL perfeitamente
add_executable(${EXECUTABLE} ${APP_SOURCES} ${HAL_SOURCES})

target_include_directories(${EXECUTABLE} PRIVATE 
    ${APP_INCLUDES}
    ${HAL_INCLUDES} 
)

target_compile_definitions(${EXECUTABLE} PRIVATE USE_HAL_DRIVER ${TARGET_MCU})
target_compile_options(${EXECUTABLE} PRIVATE 
    -Wall 
    -Wpedantic 
    -Wno-unused-parameter
    -Wno-macro-redefined  # <--- Isso mata o aviso de "redefined"
)

target_link_options(${EXECUTABLE} PRIVATE
    -T${LINKER_SCRIPT}
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map
    --specs=nosys.specs
    --specs=nano.specs
    -Wl,--print-memory-usage
    -Wl,--gc-sections
)

target_link_libraries(${EXECUTABLE} PRIVATE -lc -lm)

# ==============================================================================
# 4. PÓS-BUILD
# ==============================================================================
add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${EXECUTABLE}>
)
set_target_properties(${EXECUTABLE} PROPERTIES SUFFIX ".elf")