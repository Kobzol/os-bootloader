#pragma once

#include "types.h"

void memcpy(void* dest, void* src, uint size);
void memset(void* dest, uchar value, uint size);

void int_to_ascii(int n, char* str);
void reverse(char* s);
int strlen(char* s);
