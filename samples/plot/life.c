//
//
//
void plot(unsigned char x, unsigned char y, unsigned char z);

unsigned char a1[66][64];
unsigned char a2[66][64];

unsigned long rnd;

unsigned long xorshift32()
{
	rnd ^= rnd << 13;
	rnd ^= rnd >> 17;
	rnd ^= rnd << 5;
	return rnd;
}

void
init()
{
	unsigned char x,y;
	rnd = *((int *)0x0b);
	while (rnd==0) {
		rnd += *((int *)0x0b)+1;
	}

	for (y=0; y<64; y++){ 
		for (x=0; x<66; x++){
			a1[x][y] = 0;
			a2[x][y] = 0;
		}
	}
	for (y=1; y<=48; y++){ 
		for (x=1; x<=64; x++){
			if (xorshift32()&1){
				a1[x][y] = 1;
			}
		}
	}
	for (y=1; y<=48; y++) {
		for (x=1; x<=64; x++){
			plot(x-1,y-1,a1[x][y]);
		}
	}
}

int
main(int argc, char **argv)
{
	unsigned char x,y;
	unsigned char alive;
	unsigned char x1,y1,x2,y2;

	init();
	while(1){
		for (y=1; y<=48; y++) {
			y1 = y-1;
			y2 = y+1;
			for (x=1; x<=64; x++){
				x1 = x-1;
				x2 = x+1;
				alive  = a1[x1][y1] + a1[x][y1] + a1[x2][y1];
				alive += a1[x1][y]              + a1[x2][y];
				alive += a1[x1][y2] + a1[x][y2] + a1[x2][y2];
				if (alive == 3){
					a2[x][y] = 1;
				}else if (alive != 2){
					a2[x][y] = 0;
				}
			}
		}
		for (y=1; y<=48; y++) {
			for (x=1; x<=64; x++){
				alive = a1[x][y] = a2[x][y];
				plot(x-1,y-1,alive);
			}
		}
	}
	return 0;
}
