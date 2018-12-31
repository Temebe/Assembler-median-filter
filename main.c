#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void median(char *input, char *output, unsigned int width, unsigned int height);

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
		case -4:
			printf("Cannot create result file.\n");
			break;
		default:
			printf("Unknown error.\n");
			break;
	}
	return msg;
}

int main(int argc, char* argv[]) { 
	FILE *file = 0;
	BMPHeader inputHeader;
	//char color[] = {0x10, 0x30, 0x20, 0x41, 0x45, 0xab, 0xa2, 0x01}; //pointers for counting 
	unsigned char *color = (char*) malloc(12);
	unsigned char *img;
	unsigned char *result;
	unsigned int width, height; //our input and output will have these the same
	int i = 0;

	if(argc<2)
		return error(-1);
	printf("File name: %s\n", argv[1]);

	file = fopen(argv[1], "rb");
	if(file == 0)
		return error(-2);

	fread((void*) &inputHeader, sizeof(inputHeader), 1, file);
	if(inputHeader.type != 0x4D42)
		return error(-3);
	
	width = inputHeader.biWidth;
	height = inputHeader.biHeight;
	printf("Image res: %d x %d\n", width, height);

	img = (unsigned char*) malloc(width * height * 3); //We'll need surface times 3 because of 3 colors
	fread(img, width*height*3, 1, file);
	fclose(file);
	file = fopen("result.bmp", "wb");
	if(file == 0)
		return error(-4);

	result = (unsigned char*) malloc(width * height * 3);
	median(img, result, width, height);
	for(i = 0; i < 9; i++)
		printf("%#x\n", result[i]);
	fwrite((void*) &inputHeader, sizeof(inputHeader), 1, file);
	fwrite(result, width*height*3, 1, file);
	printf("Output file: result.bmp\n");

	free(img);
	free(result);
	fclose(file);
	return 0;
}