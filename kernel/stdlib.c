#include "stdlib.h"

void memcpy(void* dest, void* src, uint size)
{
	uchar* d = (uchar*) dest;
	uchar* s = (uchar*) src;
	while (size--)
	{
		*d++ = *s++;
	}
}
void memset(void* dest, uchar value, uint size)
{
	uchar* d = (uchar*) dest;
	while (size--)
	{
		*d++ = value;
	}
}

void int_to_ascii(int n, char* str)
{
    int i, sign;
    if ((sign = n) < 0) n = -n;
    i = 0;
    do
    {
        str[i++] = n % 10 + '0';
    } while ((n /= 10) > 0);

    if (sign < 0) str[i++] = '-';
    str[i] = '\0';

    reverse(str);
}
void reverse(char* s)
{
    int c, i, j;
    for (i = 0, j = strlen(s) - 1; i < j; i++, j--)
    {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}
int strlen(char* s)
{
    int i = 0;
    while (s[i] != '\0') i++;
    return i;
}
