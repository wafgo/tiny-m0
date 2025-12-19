TARGET   := tiny-m0

SRCS := startup.s
OBJS := $(SRCS:.s=.o)

.PHONY: all clean 

all: $(TARGET).elf

%.o: %.s
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -g -Og -ffreestanding -fno-builtin -Wall -Wextra -Werror -c $< -o $@

$(TARGET).elf: $(OBJS) link.ld
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -g -Og -ffreestanding -fno-builtin -Wall -Wextra -Werror $(OBJS) -T link.ld -nostdlib -Wl,-Map=$(TARGET).map -o $@

clean:
	rm -f $(OBJS) $(TARGET).elf $(TARGET).bin $(TARGET).map
