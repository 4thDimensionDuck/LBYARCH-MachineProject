#include <stdio.h>

extern void average_filter( int *in_image, int *out_image, int img_w, int img_h, int sample_size );

int main() {

	int in_image[] = { 
		1, 4, 0, 1, 3, 1,
		2, 2, 4, 2, 2, 3,
		1, 0, 1, 0, 1, 0,
		1, 2, 1, 0, 2, 2,
		2, 5, 3, 1, 2, 5,
		1, 1, 4, 2, 3, 0 
	};

	int out_image[sizeof(in_image)/sizeof(in_image[0])];

	// Parameters
	int img_w = 6, // Image Width
		img_h = 6, // Image Height
		sample_size = 3; // Sample Window Height and Width

	printf("Input Image: \n");
	for ( int i = 0; i < img_h; i++ ) {
		for ( int j = 0; j < img_w; j++ ) {
			printf("%-4d", in_image[(img_w * i + j)]);
		}
		printf("\n");
	}
	
	printf("\n");

	average_filter( in_image, out_image, img_w, img_h, sample_size );

	printf("Output Image: \n");
	for ( int i = 0; i < img_h; i++ ) {
		for ( int j = 0; j < img_w; j++ ) {
			printf("%-4d", out_image[(img_w * i + j)]);
		}
		printf("\n");
	}

	return 0;
}
