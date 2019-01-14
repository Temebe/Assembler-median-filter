#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <SFML/Graphics.h>

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
		default:
			printf("Unknown error.\n");
			break;
	}
	return msg;
}

int main(int argc, char* argv[]) { 
	sfVideoMode mode;
    sfRenderWindow* window;
    sfTexture* texture;
    sfSprite* sprite;
	sfEvent event;
	FILE *file = 0;
	BMPHeader inputHeader;
	unsigned int width, height; //our input and output will have these the same
	unsigned char *img;
	unsigned char *result;

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

	result = (unsigned char*) malloc(width * height * 3 + sizeof(inputHeader));
	memcpy(result, &inputHeader, sizeof(inputHeader));
	median(img, result + sizeof(inputHeader), width, height);
	
	// Creating window
	mode.width = width;
	mode.height = height;
	mode.bitsPerPixel = 32;
	window = sfRenderWindow_create(mode, "Median Filter ", sfResize | sfClose, NULL);

	texture = sfTexture_createFromMemory(result, width*height*3 + sizeof(inputHeader), NULL);
	sprite = sfSprite_create();
    sfSprite_setTexture(sprite, texture, sfTrue);

	while (sfRenderWindow_isOpen(window))
    {
        // Process events
        while (sfRenderWindow_pollEvent(window, &event))
        {
            // Exit
            if (event.type == sfEvtClosed)
                sfRenderWindow_close(window);
        }
        sfRenderWindow_clear(window, sfBlack);
        sfRenderWindow_drawSprite(window, sprite, NULL);
        sfRenderWindow_display(window);
    }

    sfSprite_destroy(sprite);
    sfTexture_destroy(texture);
    sfRenderWindow_destroy(window);
	free(img);
	free(result);
	return 0;
}