	.setcpu 6800
	.code
	.export __castul_f
	.code
;	uint32_t _castul_f(unsigned long a1)
__castul_f:
	des
	des
	tsx
;	if (a1 == 0)
	ldaa 4,x
	anda #$7F
	oraa 5,x
	oraa 6,x
	oraa 7,x
	bne L1_e
;	return 0;
	clra
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L0_r
L1_e:
;	int exp = 24 + EXCESS;
;		exp 0-1,x
	clra
	ldab #150
;	stb 1,x		exp = AccAB
;	sta 0,x
;	/* Move down until our first one bit is the implied bit */
L2_c:
;	while(a1 & 0xFF000000UL) {
;		a1	4-7,x
	tst 4,x
	beq	L2_b
;	exp++
;	ldb 1,x
;	lda 0,x
	addb #1
	adca #0
;	stb 1,x
;	sta 0,x
;	a1 >> = 1
	lsr 4,x
	ror 5,x
	ror 6,x
	ror 7,x
;	}
	jmp L2_c
L2_b:
;	/* Move smaller numbers up until the first 1 bit is in the implied 1 position */
L3_c:
;	while(!(a1 & HIDDEN)) {
;		HIDDEN	0x00800000
;		a1 4-7,x
	tst 5,x
	bmi L3_b
;	exp--;
	subb #1
	sbca #0
;	a1 <<= 1
	asl 7,x
	rol 6,x
	rol 5,x
	rol 4,x
	jmp L3_c
L3_b:
;	return PACK(0, exp, a1);	// a1 is unsigned, so sign bit==0
;		#define PACK(s, e, m)	((s) | (((uint32_t)(e)) << 23) | ((m) & 0x7FFFFFUL))
;		a1 4-7,x
	asl 5,x
	lsra
	rorb
	ror 5,x
	stab 4,x
	ldab 7,x
	ldaa 6,x
	ldx 5,x
	stx @hireg
;
L0_r:
	ins
	ins
	jmp __cleanup4
;
;	uint32_t _castu_f(unsigned a1)
;		return address	0-1,x
;		a1	2-3,x
	.export __castu_f
__castu_f:
	des		; workarea 6 bytes
	des		; return address	6-7,x
	des		; a1	8-9,x
	des		; r		0-3,x
	des		; exp	4-5,x
	des
	tsx
;	if (a1 == 0)
;		unsigned a1		8-9,x
	ldaa 8,x
	oraa 9,x
	bne	L5_e
;
;	clra			; a already 0
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L4_r
L5_e:
;	r = a1;			; r and a1 are unsigned.
	ldb 9,x
	stab 3,x
	ldb 8,x
	stab 2,x
	clra
	staa 1,x
	staa 0,x
;	int exp = 24 + EXCESS;
;		exp 4-5,x
	ldab #150
;	stb 5,x			; Acc A,B = exp
;	sta 4,x			; Acc A already 0
;
L6_c:
;	while(!(r & HIDDEN)) {
;		HIDDEN	0x00800000
;		r 0-3,x
	tst	1,x
	bmi	L6_b
;	exp--;
;	ldb 5,x
;	lda 4,x
	subb #1
	sbca #0
;	stb 5,x
;	sta 4,x
;	r <<= 1;
	lsl	3,x
	rol 2,x
	rol 1,x
	rol 0,x
;	}
	jmp L6_c
L6_b:
;	return PACK(0, exp, r);
	lsl 1,x
	asra
	rorb
	ror 1,x
	stab 0,x
	ldab 3,x
	ldaa 2,x
	ldx 0,x
	stx @hireg
;
L4_r:
	ins
	ins
	ins
	ins
	ins
	ins
	jmp __cleanup2
;
;	uint32_t castuc_f(unsigned char a1)
;		return address 0-2,x
;		a1 3,x
	.export __castuc_f
__castuc_f:
	des		; working space 6bytes
	des		;	return address 6-8,x
	des		;	a1	9-10,x
	des		;	uint32_t r	0-3,x
	des		;	int exp 4-5,x
	des
	tsx
	clra
;	if (a1 == 0)
	ldb 8,x
	bne	L8_e
	clrb
	staa @hireg
	stab @hireg+1
	jmp L7_r
L8_e:
;	r = a1;
	stab 3,x		; b already has 8,x
;	clra			; a already 0
	staa 2,x
	staa 1,x
	staa 0,x
;	int exp = 24 + EXCESS;
	ldab #150
;	clra			; a already 0
;	stb 5,x			; AccA,B keeps exp
;	sta 4,x
;
L9_c:
;	while(!(r & HIDDEN)) {
;		HIDDEN	0x00800000
;		r 0-3,x
	tst	1,x
	bmi	L9_b
;	exp--;
	subb #1
	sbca #0
;	r <<= 1;
	asl	3,x
	rol	2,x
	rol 1,x
	rol 0,x
	bra L9_c
L9_b:
;    return PACK(0, exp, r);
	asl 1,x
	lsra
	rorb
	ror 1,x
	stab 0,x
	ldab 3,x
	ldaa 2,x
	ldx 1,x
	stx @hireg
;
L7_r:
	ins
	ins
	ins
	ins
	ins
	ins
	jmp __cleanup1
	.export __castl_f
__castl_f:
;	uint32_t castl_f(long a1)
;		return address 0-1,x
;		a1 2-5,x
	tsx
;	if (a1 < 0)
	ldab 2,x
	bpl L11_e
;	return _negatef(_castul_f(-a1));
;		-a1
	com	2,x
	com 3,x
	com 4,x
	neg 5,x
	bne L11_s1
	inc 4,x
	bne L11_s1
	inc 3,x
	bne L11_s1
	inc 2,x
L11_s1:
;		_castul_f(-a1));
	ldab 5,x
	pshb
	ldab 4,x
	pshb
	ldab 3,x
	pshb
	jsr __castul_f
;		_negatef(_castul_f(-a1));
	psha
	ldaa @hireg
	eora #$80
	staa @hireg
	pula
;
	bra L10_r
L11_e:
;	return _castul_f(a1);
	ldab 5,x
	pshb
	ldab 4,x
	pshb
	ldab 3,x
	pshb
	ldab 2,x
	pshb
	jsr __castul_f+0
;
L10_r:
	jmp __cleanup4
	.export __cast_f
__cast_f:
;	uint32_t _cast_f(int a1)
;		return address 0-1,x
;		a1	2-3,x
	tsx
;	if (a1 < 0)
	ldab 3,x
	ldaa 2,x
	bpl L13_e
;	return _negatef(_castu_f(-a1));
	nega
	negb
	sbca #0
	pshb
	psha
	jsr __castu_f
__cast_f_negative:
	psha
	ldaa @hireg
	eora #$80
	staa @hireg
	pula
;
	bra L12_r
L13_e:
;	return _castu_f(a1);
	pshb
	psha
	jsr __castu_f
;
L12_r:
	jmp __cleanup2
;
;	uint32_t castc_f(signed char a1)
;		return address 0-1,x
;		a1	2,x
;
	.export __castc_f
__castc_f:
	tsx
;	if (a1 < 0)
	ldb 2,x
	bpl	L15_e
;make local ptr off 2, rlim 255 noff 2
	negb
	pshb
	jsr __castuc_f
	psha
	ldaa @hireg
	eora #$80
	staa @hireg
	pula
	bra	L14_r
L15_e:
;make local ptr off 2, rlim 255 noff 2
	pshb
	jsr __castuc_f
;
L14_r:
	jmp __cleanup1
