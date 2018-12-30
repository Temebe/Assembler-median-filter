#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char median(char *s);

typedef struct {
	unsigned short type;
	unsigned int size;
	unsigned short reserved1;
	unsigned short reserved2;
	unsigned int offset;
	unsigned int biSize;
	unsigned int biWidth;
	unsigned int biHeight;
	unsigned short biPlanes;
	unsigned short biBitCount;
	unsigned int biCompression;
	unsigned int biSizeImage;
	unsigned int biXPelsPerMeter;
	unsigned int biYPelsPerMeter;
	unsigned int biClrUsed;
	unsigned int biClrImportant;
	/*unsigned char biClrImportant; 
	unsigned char biClrRotation;
	unsigned short biReserved*/ 
} BMPHeader;

int error(int msg) {
	printf("An error occured: ");
	switch(msg) {
		case -1:
			printf("Arg missing\n");
			break;
		case -2:
			printf("Cannot open file.\n");
			break;
		case -3:
			printf("BMP is not BM type.\n");
			break;
		default:
			printf("Unknown error.\n");
			break;
	}
	return msg;
}

int main(int argc, char* argv[]) { 
	FILE *input = 0;
	BMPHeader inputHeader;
	//char color[] = {0x10, 0x30, 0x20, 0x41, 0x45, 0xab, 0xa2, 0x01}; //pointers for counting 
	unsigned char *color = (char*) malloc(12);
	unsigned char result;
	int width, height; //our input and output will have these the same
	int i = 0;

	if(argc<2)
		return error(-1);

	printf("File name: %s\n", argv[1]);

	input = fopen(argv[1], "rb");
	if(input == 0)
		return error(-2);

	fread((void*) &inputHeader, sizeof(inputHeader), 1, input);
	if(inputHeader.type != 0x4D42)
		return error(-3);
	
	width = inputHeader.biWidth;
	height = inputHeader.biHeight;
	printf("Image res: %d x %d\n", width, height);

	//Test of median
	//color = {0x10, 0x30, 0x20, 0x41, 0x45, 0xab, 0xa2, 0x01};
	for(i = 0; i < 9; i++)
		color[i] = 3*(9-i);
	for(i = 0; i < 9; i++)
		printf("%#x, ", color[i]);
	result = median(color);
	printf("\n");
	for(i = 0; i < 9; i++)
		printf("%#x, ", color[i]);
	printf("\nMedian: %x\n", result);
	printf("Size: %d\n", sizeof(result));
	printf("Output file: TODO\n");

	fclose(input);
	return 0;
}