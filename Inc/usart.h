/**
  ******************************************************************************
  * File Name          : USART.h
  * Description        : This file provides code for the configuration
  *                      of the USART instances.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __usart_H
#define __usart_H
#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "main.h"

#ifdef STM32_BOARD_STM32F413H_DISCOVERY
extern UART_HandleTypeDef huart6;
void MX_USART6_UART_Init(void);
#endif

#ifdef STM32_BOARD_STM32F769I_DISCOVERY
extern UART_HandleTypeDef huart1;
void MX_USART1_UART_Init(void);
#endif

#ifdef __cplusplus
}
#endif
#endif /*__ usart_H */
