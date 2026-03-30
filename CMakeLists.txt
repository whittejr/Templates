cmake_minimum_required(VERSION 3.22)

# O nome do projeto agora é genérico e se baseia na pasta do repositório
project(embedded-env C CXX ASM)

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

# Configurações de Padrão C/C++
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(PROJ_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(EXECUTABLE ${CMAKE_PROJECT_NAME})

# ==============================================================================
# 1. ROTEAMENTO DE HARDWARE (A Mágica da Modularização)
# ==============================================================================
# A variável MCU_FAMILY vem do CMakePresets.json
if(NOT DEFINED MCU_FAMILY)
    message(FATAL_ERROR "MCU_FAMILY não definida! Por favor, selecione um Preset válido no VSCode.")
endif()

# Carrega o arquivo específico do chip (ex: cmake/mcu/STM32WB.cmake)
set(MCU_CONFIG_FILE "${PROJ_PATH}/cmake/mcu/${MCU_FAMILY}.cmake")
if(EXISTS "${MCU_CONFIG_FILE}")
    message(STATUS ">>> Injetando configurações de hardware para: ${MCU_FAMILY} (${TARGET_MCU})")
    include("${MCU_CONFIG_FILE}")
else()
    message(FATAL_ERROR "Arquivo de configuração não encontrado em ${MCU_CONFIG_FILE}")
endif()

# ==============================================================================
# 2. COLETA DOS SEUS ARQUIVOS (Core, Components, BSP)
# ==============================================================================
# Em vez de usar scripts externos complexos, o GLOB_RECURSE acha seus arquivos 
# automaticamente nas pastas da nossa nova arquitetura.
file(GLOB_RECURSE APP_SOURCES
    "Core/src/*.c"
    "components/*.c"
    "bsp/*.c"
)

# Define as pastas onde estão os seus arquivos .h
set(APP_INCLUDES
    "${PROJ_PATH}/Core/inc"
    "${PROJ_PATH}/components"
    "${PROJ_PATH}/bsp"
)

# ==============================================================================
# 3. CRIAÇÃO DO EXECUTÁVEL E VÍNCULOS
# ==============================================================================
add_executable(${EXECUTABLE} 
    ${APP_SOURCES}  
    ${HAL_SOURCES}  # Variável preenchida pelo cmake/mcu/STM32WB.cmake
)

target_include_directories(${EXECUTABLE} PRIVATE 
    ${APP_INCLUDES}
    ${HAL_INCLUDES} # Variável preenchida pelo cmake/mcu/STM32WB.cmake
)

target_compile_definitions(${EXECUTABLE} PRIVATE 
    "USE_HAL_DRIVER"
    "${TARGET_MCU}" # Variável injetada pelo CMakePresets.json
)

# ==============================================================================
# 4. FLAGS DE COMPILAÇÃO E LINKER
# ==============================================================================
target_compile_options(${EXECUTABLE} PRIVATE
    -Wall
    -Wpedantic
    -Wno-unused-parameter
)

# LINKER_SCRIPT foi definido dentro do seu cmake/mcu/STM32WB.cmake
target_link_options(${EXECUTABLE} PRIVATE
    -T${LINKER_SCRIPT}
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map
    --specs=nosys.specs
    --specs=nano.specs
    #-u _printf_float # Descomente se for usar sprintf com float
    -Wl,--start-group
    -lc
    -lm
    -lstdc++
    -lsupc++
    -Wl,--end-group
    -Wl,--print-memory-usage
    -Wl,--gc-sections
)

# ==============================================================================
# 5. PÓS-BUILD
# ==============================================================================
add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${EXECUTABLE}>
)

set_target_properties(${EXECUTABLE} PROPERTIES SUFFIX ".elf")