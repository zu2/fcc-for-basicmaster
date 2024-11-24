PATH:=/opt/fcc/bin:/opt/homebrew/Cellar/binutils/2.43.1/bin:$(PATH)
#
.SUFFIXES: .mot .hex .bin $(SUFFIXES)

OPT=-Os
LIBS=crt0.o

all:  libs  tools programs
clean:
	rm -f *.o *.mot *.hex


libs: $(LIBS)
tools: bmcut
programs:       plot.mot life.mot

life.bin:	life.o mb-plot.o
plot.bin:	plot.o mb-plot.o

.c.o:
	fcc $(OPT) -m6800 -c $<
#	fcc $(OPT) -m6800 -S $<

.s.o:
	fcc $(OPT) -m6800 -c $<

.o.bin:
	ld6800 -v -b -s -C0x4000 -Z0 -m $*.map -o $* crt0.o ../../support6800/dp.o $^ /opt/fcc/lib/6800/lib6800.a  /opt/fcc/lib/6800/libc.a
	./bmcut $* $*.bin

.bin.mot:
	objcopy -I binary -O ihex --adjust-vma=0x4000 $*.bin $*.hex
	objcopy -I binary -O srec --adjust-vma=0x4000 $*.bin $*.mot
	scp $*.hex /Volumes/Zesty\ D/BASICMASTER/ebmjr
	scp $*.mot /Volumes/Zesty\ D/BASICMASTER/j68_r1_4


mb-plot.o: mb-plot.s
plot.mot: plot.o mb-plot.o
bmcut: bmcut.c
	cc -o bmcut bmcut.c
