#include <stdint.h>

void kernel_main(void)
{
	int16_t *video_memory = (int16_t *)0xb8000;
	char *message = "Hello, World!";
	char ch;

	while (ch = *message++)
	{
		*video_memory++ = 0x0f00 | ch;
	}
	return;
}