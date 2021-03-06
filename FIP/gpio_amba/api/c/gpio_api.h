#ifndef _GPIO_API_H_
#	define _GPIO_API_H_
//--------------------------------------------------------
// Copyright (c) 2008-2011 by Future Design Systems Co., Ltd.
// All right reserved.
//
// http://www.future-ds.com
//--------------------------------------------------------
// VERSION = 2014.08.31.
//--------------------------------------------------------
#ifdef __cplusplus
extern "C" {
#endif

extern void     gpio_init( uint32_t inout // 0 by default, all input mode
                         , uint32_t edge  // 0 by default, all level-sesitive
                         , uint32_t pol   //~0 by default, all active-high
                         , uint32_t irq_enable); //0 by default, all disabled
extern uint32_t gpio_read            (void);
extern void     gpio_write           (uint32_t value);
extern void     gpio_interrupt_set(uint32_t edge, uint32_t pol, uint32_t enable);
extern uint32_t gpio_irq_clear       (uint32_t value);
#ifndef COMPACT_CODE
extern void     gpio_set_input_all   (void);
extern void     gpio_set_input_bit   (uint32_t bit);
extern void     gpio_set_output_all  (void);
extern void     gpio_set_output_bit  (uint32_t bit);
extern void     gpio_write_bit       (uint32_t value, uint32_t bit);
extern uint32_t gpio_irq_edge        (uint32_t value);
extern uint32_t gpio_irq_pol         (uint32_t value);
extern uint32_t gpio_irq_enable      (uint32_t value);
extern uint32_t gpio_irq_read        (void);
extern void     gpio_init_value_check(void);
#endif

#ifdef __cplusplus
}
#endif
//--------------------------------------------------------
// Revision History
//
// 2014.08.31: 'gpio_init()' modified.
// April 19, 2008: Start by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
#endif
