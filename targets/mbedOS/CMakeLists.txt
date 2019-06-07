#
# Copyright (c) 2019 The nanoFramework project contributors
# See LICENSE file in the project root for full license information.
#

# set target base location
# this has to be set before the class library modules are pulled in
if(EXISTS ${PROJECT_SOURCE_DIR}/targets/CMSIS-OS/mbedOS/${MBED_TARGET})
    # set target base location
    set(TARGET_BASE_LOCATION "${PROJECT_SOURCE_DIR}/targets/CMSIS-OS/mbedOS/${MBED_TARGET}")
    message(STATUS "Support for target board '${MBED_TARGET}' found")

        # check if MBEDOS_SOURCE was specified or if it's empty (default is empty)
        set(NO_MBEDOS_SOURCE TRUE)
        if(MBEDOS_SOURCE)
            if(NOT "${MBEDOS_SOURCE}" STREQUAL "")
                set(NO_MBEDOS_SOURCE FALSE)
            endif()
        endif()
    
        if(NO_MBEDOS_SOURCE)
            # no MBEDOS source specified, download it from it's repo
    
            # check for Git (needed here for advanced warning to user if it's not installed)
            find_package(Git)
    
            #  check if Git was found, if not report to user and abort
            if(NOT GIT_EXECUTABLE)
            message(FATAL_ERROR "error: could not find Git, make sure you have it installed.")
            endif()
    
            # mbedOS version
            set(MBEDOS_VERSION_EMPTY TRUE)
    
            # check if build was requested with a specifc mbedOS version
            if(DEFINED MBEDOS_VERSION)
                if(NOT "${MBEDOS_VERSION}" STREQUAL "")
                    set(MBEDOS_VERSION_EMPTY FALSE)
                endif()
            endif()
    
            if(MBEDOS_VERSION_EMPTY)
                # no mbedOS version actualy specified, must be empty which is fine, we'll grab the code from the mbed-os-15.12 branch
                message(STATUS "RTOS is: mbedOS (latest available code from mbed-os-15.12.0)")
                set(MBEDOS_GIT_TAG "mbed-os-15.12.0")
            else()
                message(STATUS "RTOS is: mbedOS v${MBEDOS_VERSION}")
    
                # branch naming follows the pattern 'mbed-os-15.12'
                # need to extract the major and minor numbers from the MBEDOS_VERSION parameter
                # find 1st dot in version number
                string(FIND ${MBEDOS_VERSION} "." MBEDOS_VERSION_DOT_INDEX)
                # find 2nd dot in version number
                string(FIND ${MBEDOS_VERSION} "." MBEDOS_VERSION_DOT_INDEX REVERSE)
                # extract 'short' version
                string(SUBSTRING ${MBEDOS_VERSION} 0 ${MBEDOS_VERSION_DOT_INDEX} MBEDOS_SHORT_VERSION)
    
                # set branch name
                set(MBEDOS_GIT_TAG "mbed-os-${MBEDOS_SHORT_VERSION}.0")
            endif()
    
            # need to setup a separate CMake project to download the code from the GitHub repository
            # otherwise it won't be available before the actual build step
            configure_file("${PROJECT_SOURCE_DIR}/CMake/mBedOS.CMakeLists.cmake.in"
                        "${CMAKE_BINARY_DIR}/mBedOS_Download/CMakeLists.txt")
    
            # setup CMake project for mbedOS download
            execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
                            RESULT_VARIABLE result
                            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/mbedOS_Download")
    
            # run build on mbedOS download CMake project to perform the download
            execute_process(COMMAND ${CMAKE_COMMAND} --build .
                            RESULT_VARIABLE result
                            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/mbedOS_Download")
    
            # add mbedOS as external project
            ExternalProject_Add(
                mbedOS
                PREFIX mbedOS
                SOURCE_DIR ${CMAKE_BINARY_DIR}/mbedOS_Source
                GIT_REPOSITORY  https://github.com/ARMmbed/mbed-os
                GIT_TAG ${MBEDOS_GIT_TAG}  # target specified branch
                GIT_SHALLOW 1   # download only the tip of the branch, not the complete history
                TIMEOUT 10
                LOG_DOWNLOAD 1
    
                # Disable all other steps
                CONFIGURE_COMMAND ""
                BUILD_COMMAND ""
            )
    
            # get source dir for mbedOS CMake project
            ExternalProject_Get_Property(mbedOS SOURCE_DIR)
    
        else()
            # mbedOS source was specified
    
            # sanity check is source path exists
            if(EXISTS "${MBEDOS_SOURCE}/")
                message(STATUS "RTOS is: mbedOS (source from: ${MBEDOS_SOURCE})")
    
                # check if we already have the sources, no need to copy again
                if(NOT EXISTS "${CMAKE_BINARY_DIR}/mbedOS_Source")
                    file(COPY "${MBEDOS_SOURCE}/" DESTINATION "${CMAKE_BINARY_DIR}/mbedOS_Source")
                else()
                    message(STATUS "Using local cache of mbedOS source from ${MBEDOS_SOURCE}")
                endif()
    
                #set(MBEDOS_INCLUDE_DIR ${CMAKE_BINARY_DIR}/mbedOS_Source/include) #TODO: where is the include files?
            else()
                message(FATAL_ERROR "Couldn't find mbedOS source at ${MBEDOS_SOURCE}/")
            endif()
    
            # add mbedOS as external project
            ExternalProject_Add(
                mbedOS
                PREFIX mbedOS
                SOURCE_DIR ${CMAKE_BINARY_DIR}/mbedOS_Source
                
                # Disable all other steps
                CONFIGURE_COMMAND ""
                BUILD_COMMAND ""
            )
    
            # get source dir for mbedOS CMake project
            ExternalProject_Get_Property(mbedOS SOURCE_DIR)
    
        endif()
else()
    # board NOT found
    # can't continue
    message(FATAL_ERROR "\n\nSorry but support for ${MBED_TARGET} target is not available...\n\nYou can wait for it to be added or you might want to contribute a PR.\n\n")
endif()

# Define base path for the class libraries
set(BASE_PATH_FOR_CLASS_LIBRARIES_MODULES "${PROJECT_SOURCE_DIR}/targets/CMSIS-OS/mbedOS/${MBED_TARGET}/nanoCLR")

# add target TI SimpleLink dirs
#add_subdirectory(common)
#add_subdirectory(Include)
#add_subdirectory(nanoCLR)


