#
# Copyright (c) 2017 The nanoFramework project contributors
# See LICENSE file in the project root for full license information.
#

message(STATUS "Compiling for mbed")

if(${TOOLCHAIN} STREQUAL "")
    message(FATAL_ERROR "A toolchain (eg: TOOLCHAIN_GCC_ARM) must be specified")
endif()

if("${MBEDOS_TARGET}" STREQUAL "")
    message(FATAL_ERROR "MBEDOS_TARGET must be specified")
endif()

if("${MBED_PATH}" STREQUAL "")
    message(FATAL_ERROR "MBED_PATH must be specified")
endif()

macro(glob_files var dir)
    foreach(ext ${ARGN})
        file(GLOB _tmp "${dir}/${ext}")
        set(${var} ${${var}} ${_tmp})
    endforeach()
endmacro()

if (${CMAKE_C_COMPILER_ID} STREQUAL "GNU")
    set(MBED_COMPILER_FAMILY "GCC")
elseif (${CMAKE_C_COMPILER_ID} STREQUAL "ARMCC")
    set(MBED_COMPILER_FAMILY "ARM")
else()
    # TODO: Maybe we should crash here.
    set(MBED_COMPILER_FAMILY "ARM")
endif()


# Board specific configuration
# -----------------------------
# To add another board, look at the values in the ${MBED_PATH}/targets/targets.json
# file. This along with the directory structure in the targets folder should
# be enough to fill you in on the needed information.

# if (MBEDOS_TARGET MATCHES "NUCLEO_F767ZI")
#     set(MBED_VENDOR "STM")
#     set(MBED_FAMILY "STM32F7")
#     set(MBED_CPU    "STM32F767xI")
#     set(MBED_CPU_FAMILY "CORTEX_M")
#     set(MBED_CORE   "cortex-m7")
#     set(MBED_INSTRUCTIONSET "M7")
#     set(MBED_STARTUP "startup_stm32f769xx.o")
#     set(MBED_SYSTEM "system_stm32f7xx.o")
#     set(MBED_LINK_TARGET "STM32F767xI")

#     set(MBED_SUPPORTED_LIBS
#         "USB" "RPC" "DSP")

#     # values found in ${MBED_PATH}/targets/targets.json
#     set(MBED_DEVICE_FEATURES
#         "ANALOGIN" "ANALOGOUT" "CAN" "I2C" "I2CSLAVE" "I2C_ASYNCH"
#         "INTERRUPTIN" "LOWPOWERTIMER" "PORTIN" "PORTINOUT" "PORTOUT"
#         "PWNOUT" "RTC" "SERIAL" "SERIAL_ASYNCH" "SLEEP" "SPI"
#         "SPISLAVE" "SPI_ASYNCH" "STDIO_MESASGES" "TRNG")

#     set(MBED_PREPROCESSOR_OPTS
#         "TARGET_${MBED_FAMILY}"
#         "TARGET_LIKE_CORTEX_M7"
#         "TARGET_FF_ARDUINO"
#         "__CORTEX_M7"
#         "__FPU_PRESENT=1" "__CMSIS_RTOS"
#         "ARM_MATH_CM7"
#         "STM32_D11_SPI_ETHERNET_PIN=PA_7"
#         "TRANSACTION_QUEUE_SIZE=2"
#         "TRANSACTION_QUEUE_SIZE_SPI=2"
#         "USBHOST_OTHER"
#         "MBED_CONF_PLATFORM_STDIO_BAUD_RATE=9600"
#         "MBED_CONF_PLATFORM_DEFAULT_SERIAL_BAUD_RATE=9600"
#         "MBED_CONF_PLATFORM_STDIO_FLUSH_AT_EXIT=1"
#         "MBED_CONF_PLATFORM_STIO_CONVERT_NEWLINES=0"
#     )

# elseif(MBEDOS_TARGET MATCHES "NUCLEO_F303K8")
#     set(MBED_VENDOR "STM")
#     set(MBED_FAMILY "STM32F3")
#     set(MBED_CPU    "STM32F303x8")
#     set(MBED_CPU_FAMILY "CORTEX_M")
#     set(MBED_CORE   "cortex-m4")
#     set(MBED_INSTRUCTIONSET "M4")
#     set(MBED_STARTUP "startup_stm32f303x8.o")
#     set(MBED_SYSTEM "system_stm32f3xx.o")
#     set(MBED_LINK_TARGET "STM32F303x8")

#     set(MBED_SUPPORTED_LIBS
#         "RPC" "DSP")

#     # values found in ${MBED_PATH}/targets/targets.json
#     set(MBED_DEVICE_FEATURES
#         "ANALOGIN" "ANALOGOUT" "CAN" "I2C" "I2CSLAVE" "I2C_ASYNCH"
#         "INTERRUPTIN" "LOWPOWERTIMER" "PORTIN" "PORTINOUT" "PORTOUT"
#         "PWNOUT" "RTC" "SERIAL" "SERIAL_FC" "SLEEP"
#         "SPI" "SPISLAVE" "SPI_ASYNCH" "STDIO_MESASGES"
#     )

#     set(MBED_PREPROCESSOR_OPTS
#         "TARGET_${MBED_FAMILY}"
#         "TARGET_LIKE_CORTEX_M4"
#         "TARGET_FF_ARDUINO"
#         "__CORTEX_M4"
#         "__FPU_PRESENT=1" "__CMSIS_RTOS"
#         "ARM_MATH_CM4"
#         "TRANSACTION_QUEUE_SIZE=2"
#         "TRANSACTION_QUEUE_SIZE_SPI=2"
#         "MBED_CONF_PLATFORM_STDIO_BAUD_RATE=9600"
#         "MBED_CONF_PLATFORM_DEFAULT_SERIAL_BAUD_RATE=9600"
#         "MBED_CONF_PLATFORM_STDIO_FLUSH_AT_EXIT=1"
#         "MBED_CONF_PLATFORM_STIO_CONVERT_NEWLINES=0"
#     )

#else
if(MBEDOS_TARGET MATCHES "DISCO_F769NI")
    set(MBED_VENDOR "STM")
    set(MBED_FAMILY "STM32F7")
    set(MBED_CPU    "STM32F769xI")
    set(MBED_CPU_FAMILY "CORTEX_M")
    set(MBED_CORE   "Cortex-M7FD")
    set(MBED_INSTRUCTIONSET "M7")
    set(MBED_STARTUP "startup_stm32f7xx.o")
    set(MBED_SYSTEM "system_stm32f7xx.o")
    set(MBED_LINK_TARGET "STM32F769xI")

    set(MBED_SUPPORTED_LIBS
        "RPC" "DSP")

    # values found in ${MBED_PATH}/targets/targets.json
    set(MBED_DEVICE_FEATURES
        "ANALOGOUT" "CAN" "EMAC" "SERIAL_ASYNCH" "TRNG"
        "FLASH" "USBDEVICE" "MPU" "QSPI"
    )

    set(MBED_PREPROCESSOR_OPTS
        "TARGET_${MBED_FAMILY}"
        "TARGET_LIKE_CORTEX_M7"
        "TARGET_FF_ARDUINO"
        "__CORTEX_M7"
        "__FPU_PRESENT=1" 
        "__CMSIS_RTOS"
        "ARM_MATH_CM7"
        "TRANSACTION_QUEUE_SIZE=2"
        "TRANSACTION_QUEUE_SIZE_SPI=2"
        "MBED_CONF_PLATFORM_STDIO_BAUD_RATE=9600"
        "MBED_CONF_PLATFORM_DEFAULT_SERIAL_BAUD_RATE=9600"
        "MBED_CONF_PLATFORM_STDIO_FLUSH_AT_EXIT=1"
        "MBED_CONF_PLATFORM_STIO_CONVERT_NEWLINES=0"
    )

else ()
    message(FATAL_ERROR "This cmake file only supports DISCO_F769NI, NUCLEO_F767ZI and NUCLEO_F303K8 for the time being.")
endif()

foreach(feature ${MBED_DEVICE_FEATURES})
    set(MBED_DEFINES "${MBED_DEFINES} -DDEVICE_${feature}=1")
endforeach()

foreach(opt ${MBED_PREPROCESSOR_OPTS})
    set(MBED_DEFINES "${MBED_DEFINES} -D${opt}")
endforeach()

message(STATUS "Building for ${MBEDOS_TARGET}")

# -----------------------------------
# Finish setting up toolchain

set(MBED_COMMON_FLAGS
    -Wall
    -Wextra
    -mthumb
    -Wno-unused-parameter
    -Wno-missing-field-initializers
    -MMD
    -fmessage-length=0               # error messages on single line
    -fno-exceptions                  #
    -fno-common                      # place tentative definitions in the data section
    -fno-builtin                     #
    -ffunction-sections              # allows more aggressive optimizations
    -fdata-sections                  # allows more aggressive optimizations
    -funsigned-char                  # force all chars to be compiled unsigned
    -fno-delete-null-pointer-checks  # force compiler to assume we can't access memory address 0. enables some optimizations
    -fomit-frame-pointer             # aggressively look to omit frame pointers
    -mtune=${MBED_CORE}
    -mcpu=${MBED_CORE}
    -DTARGET_${MBEDOS_TARGET}
    -DTARGET_${MBED_INSTRUCTIONSET}
    -DTARGET_${MBED_VENDOR}
    -DTOOLCHAIN_GCC_ARM              # TODO: Support other toolchains
    -DTOOLCHAIN_GCC
    ${MBED_DEFINES}
)

set(MBED_COMMON_FLAGS_RELEASE ${MBED_COMMON_FLAGS}
    "-Os"
    "-DNDEBUG"
)

set(MBED_COMMON_FLAGS_DEBUG ${MBED_COMMON_FLAGS}
    "-O0"
    "-g3"
    "-DMBED_DEBUG"
    "-DMBED_TRAP_ERRORS_ENABLED=1"
)

set(MBED_COMMON_LINKER_FLAGS
    "-Wl,--no-wchar-size-warning"
    "-Wl,--gc-sections"               # eliminate unused sections and symbols from output
    "-Wl,--wrap,main"
    "-Wl,--wrap,malloc_r"
    "-Wl,--wrap,free_r"
    "-Wl,--wrap,realloc_r"
    "-Wl,--wrap,memalign_r"
    "-Wl,--wrap,calloc_r"
    "-Wl,--wrap,exit"
    "-Wl,--wrap,atexit"
    "-Wl,-n"
    "-T${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/device/${TOOLCHAIN}/${MBED_LINK_TARGET}.ld"
    "-static"
    "--specs=${MBED_STD_LIB}"
)

if(${MBED_FLOAT_PRINTF})
    set(MBED_COMMON_LINKER_FLAGS ${MBED_COMMON_LINKER_FLAGS} "-Wl,-u -Wl,_printf_float")
endif()

if(${MBED_FLOAT_SCANF})
    set(MBED_COMMON_LINKER_FLAGS ${MBED_COMMON_LINKER_FLAGS} "-Wl,-u -Wl,_scanf_float")
endif()

set(MBED_LIBS stdc++ supc++ m gcc g c nosys rdimon)

string(REPLACE ";" " " MBED_COMMON_FLAGS_STR "${MBED_COMMON_FLAGS}")
string(REPLACE ";" " " MBED_COMMON_FLAGS_REL_STR "${MBED_COMMON_FLAGS_RELEASE}")
string(REPLACE ";" " " MBED_COMMON_FLAGS_DBG_STR "${MBED_COMMON_FLAGS_DEBUG}")
string(REPLACE ";" " " MBED_COMMON_LINKER_STR "${MBED_COMMON_LINKER_FLAGS}")

set(CMAKE_C_FLAGS "${MBED_COMMON_FLAGS_STR} -std=gnu99")
set(CMAKE_CXX_FLAGS "${MBED_COMMON_FLAGS_STR} -fno-rtti")
set(CMAKE_CXX_FLAGS_RELEASE "${MBED_COMMON_FLAGS_REL_STR} -fno-rtti")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${MBED_COMMON_FLAGS_REL_STR} -fno-rtti")
set(CMAKE_CXX_FLAGS_DEBUG "${MBED_COMMON_FLAGS_DBG_STR} -fno-rtti")
set(CMAKE_EXE_LINKER_FLAGS ${MBED_COMMON_LINKER_STR})


# Set of directories where we will pull source files and headers from.
# We build up this list and eventually glob all of its contents.

# NOTE: The order of these directories matters. Some source files define
# symbols with weak references that will not get overridden at link time
# if they are not in the correct order. If you ever run into a problem
# where something like an interrupt handler isn't being called as you
# would expect, try looking at libmbed-os

set(MBED_SOURCE_DIRS
    "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/TARGET_${MBEDOS_TARGET}"
    "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/device/${TOOLCHAIN}"
    "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/device/"
    "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}"
    "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/device"
    "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}"
    "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}"
    "${MBED_PATH}"
    "${MBED_PATH}/platform"
    "${MBED_PATH}/hal"
    "${MBED_PATH}/cmsis"
    "${MBED_PATH}/cmsis/TARGET_${MBED_CPU_FAMILY}"
    "${MBED_PATH}/cmsis/TARGET_${MBED_CPU_FAMILY}/TOOLCHAIN_${MBED_COMPILER_FAMILY}"
    "${MBED_PATH}/drivers"

)

if("USB" IN_LIST MBED_SUPPORTED_LIBS AND ${MBED_USE_USB})
    message(STATUS "Using USB Library")
    set(MBED_SOURCE_DIRS ${MBED_SOURCE_DIRS}
        "${MBED_PATH}/features/unsupported/USBDevice/USBAudio"
        "${MBED_PATH}/features/unsupported/USBDevice/USBDevice"
        "${MBED_PATH}/features/unsupported/USBDevice/USBDevice/TARGET_${MBED_VENDOR}"
        "${MBED_PATH}/features/unsupported/USBDevice/USBDevice/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/TARGET_${MBEDOS_TARGET}"
        "${MBED_PATH}/features/unsupported/USBDevice/USBHID"
        "${MBED_PATH}/features/unsupported/USBDevice/USBMIDI"
        "${MBED_PATH}/features/unsupported/USBDevice/USBMSD"
        "${MBED_PATH}/features/unsupported/USBDevice/USBSerial"
    )
elseif(${MBED_USE_USB})
    message(WARNING "USB Library is not supported for ${MBEDOS_TARGET}")
endif()

if("DSP" IN_LIST MBED_SUPPORTED_LIBS AND ${MBED_USE_DSP})
    message(STATUS "Using DSP Library")
    set(MBED_SOURCE_DIRS ${MBED_SOURCE_DIRS}
        "${MBED_PATH}/features/unsupported/dsp/dsp"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/BasicMathFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/CommonTables"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/ComplexMathFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/ControllerFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/FastMathFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/FilteringFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/MatrixFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/StatisticsFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/SupportFunctions"
        "${MBED_PATH}/features/unsupported/dsp/cmsis_dsp/TransformFunctions"
    )
elseif (${MBED_USE_DSP})
    message(WARNING "DSP Library is not supported for ${MBEDOS_TARGET}")
endif()

if ("RPC" IN_LIST MBED_SUPPORTED_LIBS AND ${MBED_USE_RPC})
    message(STATUS "Using RPC Library")
    set(MBED_SOURCE_DIRS ${MBED_SOURCE_DIRS}
        "${MBED_PATH}/features/unsupported/rpc"
    )
elseif(${MBED_USE_RPC})
    message(WARN "RPC library not supported for ${MBEDOS_TARGET}")
endif()

if ("LOCALFILESYSTEM" IN_LIST MBED_SUPPORTED_LIBS AND ${MBED_USE_FILESYSTEM})
    message(STATUS "Using LocalFileSystem Library")
    set(MBED_SOURCE_DIRS ${MBED_SOURCE_DIRS}
        "${MBED_PATH}/features/filesystem/"
        "${MBED_PATH}/features/filesystem/bd"
        "${MBED_PATH}/features/filesystem/fat"
        "${MBED_PATH}/features/filesystem/fat/ChaN"
    )
elseif (${MBED_USE_FILESYSTEM})
    message(WARNING "Selected device: ${MBEDOS_TARGET} does not support the local file system library")
endif()

# build list of source files and header files
foreach(dir ${MBED_SOURCE_DIRS})
    glob_files(MBED_SOURCE_FILES ${dir} "*.cpp" "*.c" "*.S" "*.obj" "*.o")
    glob_files(MBED_HEADER_FILES ${dir} "*.h")
endforeach()


# print debugging information
if (${MBED_CMAKE_DEBUG})
    message(STATUS "Source Files:")
    foreach(src ${MBED_SOURCE_FILES})
        message(STATUS "  ${src}")
    endforeach()

    message(STATUS "Header Files:")
    foreach(src ${MBED_HEADER_FILES})
        message(STATUS "  ${src}")
    endforeach()

    message(STATUS "Include Directories")
    foreach(dir ${MBED_SOURCE_DIRS})
      message(STATUS "  ${dir}")
    endforeach()

    message(STATUS "Libraries:")
    message(STATUS "    ${MBED_LIBS}")

    message(STATUS "Object Files:")
    foreach(obj ${MBED_OBJECTS})
      message(STATUS "  ${obj}")
    endforeach()

    message(STATUS "Command line preprocessor flags:")
    foreach(opt ${MBED_DEFINES})
        message(STATUS " ${opt}")
    endforeach()
endif()

#add_library(mbed-os STATIC ${MBED_SOURCE_FILES} ${MBED_HEADER_FILES})
#target_include_directories(mbed-os PUBLIC ${MBED_SOURCE_DIRS})

# Helpful user end macro
# mbed_executable(<name> [SOURCES ...] [INCLUDE_DIRS ...] [LIBS ...])
#macro(mbed_executable name)
#    set(options _OPTIONAL)
#    set(oneValueArgs _ONEV)
#    set(multiValueArgs SOURCES INCLUDE_DIRS LIBS)
#    cmake_parse_arguments(MBED_EXECUTABLE  "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
#    add_executable(${name} ${MBED_EXECUTABLE_SOURCES})
#    target_include_directories(${name} PRIVATE ${MBED_SOURCE_DIRS} ${MBED_EXECUTABLE_INCLUDE_DIRS})
#    target_link_libraries(${name} mbed-os ${MBED_EXECUTABLE_LIBS} ${MBED_LIBS})
#
#    if (${MBED_MAKE_UPLOAD_TARGETS})
#        # Upload to device
#        add_custom_target(upload-${name}
#            DEPENDS ${name}
#            COMMAND ${CMAKE_OBJCOPY} -O binary ${name} ${name}.bin
#            COMMAND cp ${name}.bin ${MBED_MOUNT}
#        )
#    endif()
#endmacro()


include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(MBEDOS DEFAULT_MSG MBED_SOURCE_DIRS MBED_SOURCE_FILES)
