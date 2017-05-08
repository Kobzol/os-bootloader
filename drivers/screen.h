#pragma once

#define  VIDEO_ADDRESS 0xB8000
#define  MAX_ROWS  25
#define  MAX_COLS  80

//  Attribute  byte  for  our  default  colour  scheme.
#define  WHITE_ON_BLACK 0x0F

//  Screen  device I/O ports
#define  REG_SCREEN_CTRL 0x3D4
#define  REG_SCREEN_DATA 0x3D5

int get_screen_offset(int row, int col);
int get_cursor();
void set_cursor(int offset);

void clear_screen();

void print_char(char c, int row, int col, char attr);
void print_at(char* message, int row, int col);
void print(char* message);
