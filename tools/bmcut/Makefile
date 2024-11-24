PATH:=/opt/fcc/bin:/opt/homebrew/Cellar/binutils/2.43.1/bin:$(PATH)

.SUFFIXES: .mot .hex .bin $(SUFFIXES)

OPT=-Os
LIBS=crt0.o

all:  tools
clean:
	rm -f *.o *.mot *.hex

tools: bmcut

bmcut: bmcut.c
	cc -o bmcut bmcut.c

