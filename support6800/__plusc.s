;
;	Compute TOS + B -> B
;
		.export __plusc

		.code
__plusc:
		tsx
		addb 2,x
		ldx 0,x
		ins
		ins
		ins
		jmp 0,x
