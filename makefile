CC=arm-none-eabi-gcc
#CC=arm-none-eabi-g++
MACH=cortex-m4
CFLAGS= -c -mcpu=$(MACH) -mthumb -std=gnu11 -Wall -O0
#CFLAGS= -c -mcpu=$(MACH) -mthumb -std=gnu++11 -Wall -O0
LFLAGS= -nostdlib -T core/stm32f446re/stm32f446xx.ld -Wl,-Map=$(OUTPUT_FOLDER)/final.map

#VPATH = ./app/

OUTPUT_FOLDER = build

all:main.o startup_stm32f446xx.o rcc.o timer.o gpio.o debug.o usart.o i2c.o stdlibc.o lcd162a.o final.elf

#main app
main.o:app/main/main.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#startup file
startup_stm32f446xx.o:core/stm32f446re/startup/startup_stm32f446xx.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#rcc config
rcc.o:app/libs/rcc/rcc.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#timer config
timer.o:app/libs/timer/timer.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#gpio config
gpio.o:app/libs/gpio/gpio.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#debug config
debug.o:app/libs/debug/debug.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#stdlibc config
stdlibc.o:app/libs/stdlib/stdlibc.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#usart config
usart.o:app/protocols/usart/usart.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#i2c config
i2c.o:app/protocols/i2c/i2c.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

#lcd162a lib
lcd162a.o:app/devices/output/LCD162A/LCD162A.c
	$(CC) $(CFLAGS) -o $(OUTPUT_FOLDER)/$@ $^

final.elf:main.o startup_stm32f446xx.o rcc.o timer.o gpio.o debug.o usart.o i2c.o lcd162a.o stdlibc.o
	$(CC) $(LFLAGS) $(OUTPUT_FOLDER)/*.o  -o $(OUTPUT_FOLDER)/$@

clean-windows:
	@del /s *.o *.elf *.map

clean:
	rm -rf **/*.o **/*.elf

load:
	openocd -f board/stm32f4discovery.cfg