cmake_minimum_required(VERSION 3.22)

project(stm32wb55-Template C CXX ASM)

message("Build type: "              ${CMAKE_BUILD_TYPE})

set(CMAKE_C_STANDARD                11)
set(CMAKE_C_STANDARD_REQUIRED       ON)
set(CMAKE_C_EXTENSIONS              ON)
set(CMAKE_CXX_STANDARD              17)
set(CMAKE_CXX_STANDARD_REQUIRED     ON)
set(CMAKE_CXX_EXTENSIONS            ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS   ON)

# includes
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
include(SourceList)
include(IncludeList)

set(compiler_define ${compiler_define}
    "USE_HAL_DRIVER"
    "STM32WB55xx"
)

set(PROJ_PATH                       ${CMAKE_CURRENT_SOURCE_DIR})
set(LINKER_SCRIPT               		${PROJ_PATH}/core/linker/stm32wb55xx_flash_cm4.ld)
# The use project name for binary file name
set(EXECUTABLE                      ${CMAKE_PROJECT_NAME})

add_executable(${EXECUTABLE} ${source_list})
target_include_directories(${EXECUTABLE} PRIVATE ${include_list}) 
target_compile_definitions(${EXECUTABLE} PRIVATE ${compiler_define})

# Compiler options
target_compile_options(${EXECUTABLE} PRIVATE
	# ${CPU_FLAGS}
	-Wall
	-Wpedantic
	-Wno-unused-parameter
)
# Linker options
target_link_options(${EXECUTABLE} PRIVATE
	-T${LINKER_SCRIPT}
	# ${CPU_FLAGS}
	-Wl,-Map=${CMAKE_PROJECT_NAME}.map
	--specs=nosys.specs
	#-u _printf_float                # STDIO float formatting support
	-Wl,--start-group
	-lc
	-lm
	-lstdc++
	-lsupc++
	-Wl,--end-group
	-Wl,--print-memory-usage
)
# Execute post-build to print size
add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
	COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${EXECUTABLE}>
)
set_target_properties(${EXECUTABLE}
    PROPERTIES
    SUFFIX ".elf"
)