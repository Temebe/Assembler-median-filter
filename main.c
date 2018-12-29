#include <stdio.h>
void median(char *s, char a, char b);

int main(int argc, char* argv[])
{ 

	if (argc<2)
	{
		printf("Arg missing\n");
		return 0;
	}
  printf("File address: %s", argv[1]);
  median(argv[1], 'c', 'i');
  //printf("Output string: %s\n", argv[1]);
  return 0;
}
