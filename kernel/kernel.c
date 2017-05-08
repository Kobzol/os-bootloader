#include "low_level.h"
#include "../cpu/isr.h"

#include "../drivers/screen.h"
#include "../drivers/keyboard.h"

static void init()
{
	// screen
	set_cursor(0);
	
	// interrupts
	isr_install();
	asm volatile("sti");
}

void main()
{
	init();
	//init_timer(50);
	init_keyboard();
}
