void test()
{
	char* vidmem = (char*) 0xB8000;
	*vidmem++ = 'X';
	*vidmem++ = 0x0f;
	*vidmem++ = 'Y';
	*vidmem++ = 0x0f;
}

void main()
{
	test();
}
