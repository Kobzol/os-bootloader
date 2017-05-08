#include "screen.h"
#include "../kernel/stdlib.h"
#include "../kernel/low_level.h"

int get_screen_offset(int row, int col)
{
	return (row * MAX_COLS + col);
}

int get_cursor()
{
	port_byte_out(REG_SCREEN_CTRL, 14);
	int offset = (int) port_byte_in(REG_SCREEN_DATA) << 8;
	
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	
	return offset;
}
void set_cursor(int offset)
{
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)((offset >> 8) & 0xFF));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xFF));
}
static int handle_scrolling(int offset)
{
	if (offset < MAX_ROWS * MAX_COLS) return offset;
	
	// copy rows up by one
	for (int i = 1; i < MAX_ROWS; i++)
	{
		memcpy((void*)(VIDEO_ADDRESS + get_screen_offset(i - 1, 0) * 2),
			(void*)(VIDEO_ADDRESS + get_screen_offset(i, 0) * 2),
			MAX_COLS * 2);
	}
	
	// clear last line
	char* last_line = (char*)(VIDEO_ADDRESS + get_screen_offset(MAX_ROWS - 1, 0) * 2);
	memset(last_line, 0, MAX_COLS * 2);
	
	offset -= MAX_COLS;
	
	return offset;
}

void clear_screen()
{
	for (int row = 0; row < MAX_ROWS; row++)
	{
		for (int col = 0; col < MAX_COLS; col++)
		{
			print_char(' ', row, col, WHITE_ON_BLACK);
		}
	}
	
	set_cursor(0);
}

void print_char(char c, int row, int col, char attr)
{
	unsigned char* vidmem = (unsigned char*) VIDEO_ADDRESS;
	if (attr == 0)
	{
		attr = WHITE_ON_BLACK;
	}
	
	
	int offset =  get_cursor();
	if (row >= 0 && col >= 0)
	{
		offset = get_screen_offset(row, col);
	}
	
	if (c == '\n')
	{
		int activeRow = offset / MAX_COLS;
		offset = get_screen_offset(activeRow, MAX_COLS - 1);
	}
	else
	{
		vidmem[offset * 2] = c;	// *2 because of attr
		vidmem[offset * 2 + 1] = attr;
	}
	
	offset++;
	offset = handle_scrolling(offset);
	set_cursor(offset);
}
void print_at(char* message, int row, int col)
{
	if (row >= 0 && col >= 0) set_cursor(get_screen_offset(row, col));
	
	while (*message != '\0')
	{
		print_char(*message, row, col, WHITE_ON_BLACK);
		message++;
	}
}
void print(char* message)
{
	print_at(message, -1, -1);
}
