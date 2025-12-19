.syntax unified
.cpu cortex-m0plus
.thumb


.equ IOMUX_BASE,        0x40428000
.equ GPIO0_BASE,        0x400A0000
.equ PINCM23,           (IOMUX_BASE + 23*4)
.equ PINCM_GPIO_OUT,    ((1 << 0) | (1 << 7))
.equ GPIO_DOE31_0,      (GPIO0_BASE + 0x12c0)
.equ GPIO_DOUTTGL31_0,  (GPIO0_BASE + 0x12b0)
.equ PA22_MASK,         (1 << 22)
.equ GPIO0_PWREN,   (GPIO0_BASE + 0x800)
.extern __stack_top



.section .isr_vector, "a", %progbits
.align  2
.word   __stack_top
.word   Reset_Handler            /* 1  Reset */
.word   NMI_Handler              /* 2  NMI */
.word   HardFault_Handler        /* 3  HardFault */
.word   0                        /* 4  Reserved */
.word   0                        /* 5  Reserved */
.word   0                        /* 6  Reserved */
.word   0                        /* 7  Reserved */
.word   0                        /* 8  Reserved */
.word   0                        /* 9  Reserved */
.word   0                        /* 10 Reserved */
.word   SVC_Handler              /* 11 SVCall */
.word   0                        /* 12 Reserved */
.word   0                        /* 13 Reserved */
.word   PendSV_Handler           /* 14 PendSV */
.word   SysTick_Handler          /* 15 SysTick */
	
.rept   64
.word   Default_Handler
.endr

.section .text.handlers, "ax", %progbits
.thumb_func
.global Default_Handler
Default_Handler:
1:  b 1b

.weak NMI_Handler
.thumb_set NMI_Handler, Default_Handler

.weak SVC_Handler
.thumb_set SVC_Handler, Default_Handler

.weak PendSV_Handler
.thumb_set PendSV_Handler, Default_Handler

.weak SysTick_Handler
.thumb_set SysTick_Handler, Default_Handler

.section .text.hardfault, "ax", %progbits
.thumb_func
.global HardFault_Handler
HardFault_Handler:
    mov   r0, sp
    ldr   r1, [r0, #24]
    ldr   r2, [r0, #20]
2:  b 2b

.section .text.reset, "ax", %progbits
.thumb_func
.global Reset_Handler
Reset_Handler:
    ldr r0, =GPIO0_PWREN
    ldr r1, =0x26000001
    str r1, [r0]

    nop
    nop
    nop
    nop
	
    ldr r0, =PINCM23
    ldr r1, =PINCM_GPIO_OUT
    str r1, [r0]


    ldr r0, =GPIO_DOE31_0
    ldr r1, [r0]
    ldr r2, =PA22_MASK
    orrs r1, r2
    str r1, [r0]
loop:
    ldr r0, =GPIO_DOUTTGL31_0
    ldr r1, =PA22_MASK
    str r1, [r0]

    ldr r3, =5000000
delay:
    subs r3, r3, #1
    bne  delay
    b    loop
