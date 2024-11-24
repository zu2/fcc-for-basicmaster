//
//
//
void plot(unsigned char x, unsigned char y, unsigned char z);

#if     0
void
plot(unsigned char x, unsigned char y, unsigned char z)
{
        unsigned char *p;
        unsigned char c;        // char of dot position
        unsigned char cx;
        unsigned char cy;
        unsigned char w;

        x &= 63;
        while (y>47){
                y -= 48;
        }
        cx = x&1;
        cy = y&1;
        w = cx+cx + cy;
        switch(w){
        case 0: w=1; break;
        case 1: w=2; break;
        case 2: w=4; break;
        case 3: w=8; break;
        }
        p = (((47-y)>>1)*32) +(x>>1) + 0x0100;
        c = *p;
        if (c>15) {
                c = 0;
        }
        c = (c*11) & 0x0f;
        if (z==0) {
                c &= ~w;
        }else if (z==255) {
                c ^= w;
        }else{
                c |= w;
        }
        c = (c+c+c)&0x0f;
        *p = c;
}
#endif

int
main(int argc, char **argv)
{
	unsigned char x,y;
	unsigned char dx,dy;

	x = 0; y = 0;
	dx = 1; dy = 1;

#if		0
	for(x=0; x<64; x++){
			plot(x,0,1);
	}
	for(y=0; y<48; y++){
			plot(63,y,1);
	}
	for(x=0;x<64; x--){
			plot(63-x,47,1);
	}
	for(y=0; y<48; y++){
			plot(0,47-y,1);
	}
#endif
#if     0
	for (i=0; i<100; i++){
			for (y=0; y<48; y++){
					for (x=0; x<64; x++){
							plot(x,y,-1);
					}
			}
	}
	return 0;
#endif
#if		1
	crt_clear();
	while(1){
//			*((char *)0x0100) = x+'0';
//			*((char *)0x0101) = y+'0';
			x = x+dx ; y = y+dy;
			if (x==0)       dx = 1;
			if (x==63)      dx = 255;
			if (y==0)       dy = 1;
			if (y==47)      dy = 255;
			plot(x,y,255);
	}
#endif
	getch();
	return 0;
}
