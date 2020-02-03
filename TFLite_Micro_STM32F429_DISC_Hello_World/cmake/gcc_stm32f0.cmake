SET(CMAKE_C_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m0 -Wall -std=gnu99 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m0 -Wall -std=c++11 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_ASM_FLAGS "-mthumb -mcpu=cortex-m0 -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")

SET(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -mthumb -mcpu=cortex-m0 -mabi=aapcs" CACHE INTERNAL "executable linker flags")
SET(CMAKE_MODULE_LINKER_FLAGS "-mthumb -mcpu=cortex-m0 -mabi=aapcs" CACHE INTERNAL "module linker flags")
SET(CMAKE_SHARED_LINKER_FLAGS "-mthumb -mcpu=cortex-m0 -mabi=aapcs" CACHE INTERNAL "shared linker flags")

SET(STM32_CHIP_TYPES 030x6 030x8 031x6 038xx 042x6 048x6 051x8 058xx 070x6 070xB 071xB 072xB 078xx 091xC 098xx 030xC CACHE INTERNAL "stm32f0 chip types")
SET(STM32_CODES "030.[46]" "030.8" "031.[46]" "038.6" "042.[46]" "048.6" "051.[468]" "058.8" "070.6" "070.B" "071.[8B]" "072.[8B]" "078.B" "091.[BC]" "098.C" "030.C")

MACRO(STM32_GET_CHIP_TYPE CHIP CHIP_TYPE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[fF]((03[018].[468C])|(04[28].[46])|(05[18].[468])|(07[0128].[68B])|(09[18].[BC])).*$" "\\1" STM32_CODE ${CHIP})
    SET(INDEX 0)
    FOREACH(C_TYPE ${STM32_CHIP_TYPES})
        LIST(GET STM32_CODES ${INDEX} CHIP_TYPE_REGEXP)
        IF(STM32_CODE MATCHES ${CHIP_TYPE_REGEXP})
            SET(RESULT_TYPE ${C_TYPE})
        ENDIF()
        MATH(EXPR INDEX "${INDEX}+1")
    ENDFOREACH()
    SET(${CHIP_TYPE} ${RESULT_TYPE})
ENDMACRO()

MACRO(STM32_GET_CHIP_PARAMETERS CHIP FLASH_SIZE RAM_SIZE CCRAM_SIZE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[fF](0[34579][0128]).[468BC].*$" "\\1" STM32_CODE ${CHIP})
    STRING(REGEX REPLACE "^[sS][tT][mM]32[fF]0[34579][0128].([468BC]).*$" "\\1" STM32_SIZE_CODE ${CHIP})

    IF(STM32_SIZE_CODE STREQUAL "4")
        SET(FLASH "16K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "6")
        SET(FLASH "32K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "8")
        SET(FLASH "64K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "B")
        SET(FLASH "128K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "C")
        SET(FLASH "256K")
    ENDIF()

    STM32_GET_CHIP_TYPE(${CHIP} TYPE)

    IF(${TYPE} STREQUAL 030x6)
        SET(RAM "4K")
    ELSEIF(${TYPE} STREQUAL 030x8)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 030xC)
        SET(RAM "32K")
    ELSEIF(${TYPE} STREQUAL 031x6)
        SET(RAM "4K")
    ELSEIF(${TYPE} STREQUAL 038xx)
        SET(RAM "4K")
    ELSEIF(${TYPE} STREQUAL 042x6)
        SET(RAM "6K")
    ELSEIF(${TYPE} STREQUAL 048x6)
        SET(RAM "6K")
    ELSEIF(${TYPE} STREQUAL 051x8)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 058xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 070x6)
        SET(RAM "6K")
    ELSEIF(${TYPE} STREQUAL 070xB)
        SET(RAM "16K")
    ELSEIF(${TYPE} STREQUAL 071xB)
        SET(RAM "16K")
    ELSEIF(${TYPE} STREQUAL 072xB)
        SET(RAM "16K")
    ELSEIF(${TYPE} STREQUAL 078xx)
        SET(RAM "16K")
    ELSEIF(${TYPE} STREQUAL 091xC)
        SET(RAM "32K")
    ELSEIF(${TYPE} STREQUAL 098xx)
        SET(RAM "32K")
    ENDIF()

    SET(${FLASH_SIZE} ${FLASH})
    SET(${RAM_SIZE} ${RAM})
    SET(${CCRAM_SIZE} "0K")
ENDMACRO()

FUNCTION(STM32_SET_CHIP_DEFINITIONS TARGET CHIP_TYPE)
    LIST(FIND STM32_CHIP_TYPES ${CHIP_TYPE} TYPE_INDEX)
    IF(TYPE_INDEX EQUAL -1)
        MESSAGE(FATAL_ERROR "Invalid/unsupported STM32F0 chip type: ${CHIP_TYPE}")
    ENDIF()
    GET_TARGET_PROPERTY(TARGET_DEFS ${TARGET} COMPILE_DEFINITIONS)
    IF(TARGET_DEFS)
        SET(TARGET_DEFS "STM32F0;STM32F${CHIP_TYPE};${TARGET_DEFS}")
    ELSE()
        SET(TARGET_DEFS "STM32F0;STM32F${CHIP_TYPE}")
    ENDIF()
    SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_DEFINITIONS "${TARGET_DEFS}")
ENDFUNCTION()
