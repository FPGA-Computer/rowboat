@far @interrupt void TIM2_Update_IRQ(void);
@far @interrupt void TIM2_Capture_IRQ(void);

#define IRQ13 TIM2_Update_IRQ
#define IRQ14	TIM2_Capture_IRQ
