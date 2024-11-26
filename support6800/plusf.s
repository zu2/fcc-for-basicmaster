	.setcpu 6800
	.code
	.export __plusf
	.code
__plusf:
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
	des
;	uint32_t a1, a2;
;	int32_t mant1, mant2;
;	int exp1, exp2, expd;
;	uint32_t sign = 0;
;		a1		24-27
;		a2		20-23,x
;		mant1	0-3,x
;		mant2	4-7,x
;		exp1	8-9,x
;		exp2	10-11,x
;		expd	12-13,x
;		sign 14-17,x	; only use 14,x	$80 or $00
	tsx
	clr 17,x
	clr 16,x
	clr 15,x
	clr 14,x
;	exp2 = EXP(a2);
	ldaa 20,x
	ldab 21,x
	aslb
	rola
	staa 11,x
	clr 10,x
;	mant2 = MANT(a2) << 4;
;		#define MANT(x)		(((x) & 0x7FFFFF) | HIDDEN)
	ldab 23,x
	stab 7,x
	ldab 22,x
	stab 6,x
	ldab 21,x
	orab #$80
	stab 5,x
	clr 4,x
;
	ldab #4
L0_s1:
	lsl 7,x
	rol	6,x
	rol 5,x
	rol 4,x
	decb
	bne L0_s1
;	if (SIGN(a2))
	ldaa 20,x
	bpl L1_e
;	mant2 = -mant2;
	com 4,x
	com 5,x
	com 6,x
	neg 7,x
	bne L0_s2
	inc 6,x
	bne L0_s2
	inc 5,x
	bne L0_s2
	inc 4,x
L0_s2:
;
L1_e:
;	if (!a2)
	ldab 20,x
	orab 21,x
	orab 22,x
	orab 23,x
	bne L2_e
;	return (a1);
	ldaa 26,x
	ldab 27,x
	ldx 24,x
	stx @hireg
;
	jmp L0_r
L2_e:
;	exp1 = EXP(a1);
	ldaa 24,x
	ldab 25,x
	aslb
	rola
	sta 9,x
	clr 8,x
;	mant1 = MANT(a1) << 4;
;		#define MANT(x)		(((x) & 0x7FFFFF) | HIDDEN)
;		a1		24-27
;		mant1	0-3,x
	ldab 27,x
	stab 3,x
	ldab 26,x
	stab 2,x
	ldab 25,x
	orab #$80
	stab 1,x
	clr 0,x
;
	ldab #4
L2_s1:
	lsl 3,x
	rol 2,x
	rol 1,x
	rol 0,x
	decb
	bne L2_s1
;	if (a1 & 0x80000000UL)
	ldaa 24,x
	bpl L3_e
;	mant1 = -mant1;
	com 0,x
	com 1,x
	com 2,x
	neg 3,x
	bne L3_e
	inc 2,x
	bne L3_e
	inc 1,x
	bne L3_e
	inc 0,x
;
L3_e:
;	if (!a1)
	ldab 24,x
	orab 25,x
	orab 26,x
	orab 27,x
	bne L4_e
;	return (a2);
	ldaa 22,x
	ldab 23,x
	ldx 20,x
	stx @hireg
;
	jmp L0_r
L4_e:
;	expd = exp1 - exp2;
	ldb 9,x
	lda 8,x
;
	subb 11,x
	sbca 10,x
;
	stb 13,x
	sta 12,x
;	if (expd > 25)
	subb #25
	sbca #0
	bgt	L5_s1
	blt L5_e
	tstb
	beq	L5_e
;	return (a1);
L5_s1:
	ldaa 26,x
	ldab 27,x
	ldx 24,x
	stx @hireg
;
	jmp L0_r
L5_e:
;	if (expd < -25)
	ldab 13,x
	ldaa 12,x
	subb #231
	sbca #255
	bge L6_e
;	return (a2);
	ldaa 22,x
	ldab 23,x
	ldx 20,x
	stx @hireg
;
	jmp L0_r
L6_e:
;	if (expd < 0) {
	ldab 13,x
	bpl L7_e
;	expd = -expd;
	ldaa 12,x
	nega
	negb
	sbca #0
	stab 13,x
	staa 12,x
;	exp1 += expd;
	addb 9,x
	adca 8,x
;
	stb 9,x
	sta 8,x
;	mant1 >>= expd;
;		mant1 0-3,x
;		expd  12-13,x
;			-25 <= expd <= expd
	ldab 13,x
	beq L7_e
L7_s1:
	asr	0,x
	ror 1,x
	ror 2,x
	ror 3,x
	decb
	bne L7_s1
	jmp L7_f
L7_e:
;	} else {
;	mant2 >>= expd;
;		mant2	4-7,x
	ldab 13,x
	beq L7_f
L7_e2:
	asr 4,x
	ror 5,x
	ror 6,x
	ror 7,x
	decb
	bne L7_e2
;
L7_f:
;	mant1 += mant2;
	ldab 7,x
	addb 3,x
	stab 3,x
	ldab 6,x
	adcb 2,x
	stab 2,x
	ldab 5,x
	adcb 1,x
	stab 1,x
	ldab 4,x
	adcb 0,x
	stab 0,x
;	sign = 0;
	clr 14,x
;	if (mant1 & 0x80000000UL) {
	ldaa 0,x
	bpl L8_e
;	mant1 = -mant1;
	com 0,x
	com 1,x
	com 2,x
	neg 3,x
	bne L7_f1
	inc 2,x
	bne L7_f1
	inc 1,x
	bne L7_f1
	inc 0,x
L7_f1:
;	sign = 0x80000000;
	ldaa #$80
	staa 14,x
;
	jmp L8_f
L8_e:
;	} else if (!mant1)
	ldab 0,x
	orab 1,x
	orab 2,x
	orab 3,x
	bne L9_e
;	return (0);
	clra
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L0_r
L9_e:
L8_f:
L10_c:
;	while (mant1 < (HIDDEN << 4)) {
;		mant1	0-3,x
;		mant2	4-7,x
;		HIDDEN		0x00800000
;		HIDDEN<<4	0x08000000
	tsx
	ldab 0,x
	cmpb #$08
	bcc L10_b		; mant1 >= ...
;
;	mant1 <<= 1;
	asl	3,x
	rol	2,x
	rol	1,x
	rol	0,x
;	exp1--;
	ldb 9,x
	lda 8,x
	addb #255
	adca #255
	stb 9,x
	sta 8,x
;
	jmp L10_c
;	}
L10_b:
L11_c:
;	while (mant1 & 0xf0000000UL) {
	ldaa 0,x
	anda #$f0
;
	beq L11_b
;	if (mant1 & 1)
	ldaa 3,x
	lsra
;
	bcc L12_e
;	mant1 += 2;
	ldab 3,x
	addb #2
	stab 3,x
	bcc L11_c2
	inc 2,x
	bne L11_c2
	inc 1,x
	bne L11_c2
	inc 0,x
L11_c2:
;
L12_e:
;	mant1 >>= 1;
	lsr	0,x
	ror 1,x
	ror 2,x
	ror 3,x
;	exp1++;
	ldb 9,x
	lda 8,x
	addb #1
	adca #0
	stb 9,x
	sta 8,x
;
	jmp L11_c
;	}
L11_b:
;	mant1 &= ~(HIDDEN << 4);
	ldaa #247
	ldab #255
	staa @hireg
	stab @hireg+1
	tba
;
	tsx
	andb 3,x
	anda 2,x
	pshb
	psha
	ldaa @hireg
	ldab @hireg+1
	andb 1,x
	anda 0,x
	staa @hireg
	stab @hireg+1
	pula
	pulb
	stb 3,x
	sta 2,x
	pshb
	psha
	ldaa @hireg
	ldab @hireg+1
	stb 1,x
	sta 0,x
	staa @hireg
	stab @hireg+1
	pula
	pulb
;	if (exp1 >= 0x100)
	ldaa 16,x
	cmpa #1
	blt L13_e
;	a1 = (sign ? (SIGNBIT | INFINITY) : INFINITY);
;		a1		24-27,x
;		sign 14,x	0x80 or 0x00
;		#define SIGNBIT		0x80000000UL
;		#define INFINITY	0x78000000UL
	clr 27,x
	clr 26,x
	clr 25,x
	ldaa 14,x
	oraa #$78
	staa 24,x
;
	jmp L13_f
L13_e:
;	else if (exp1 < 0)
	ldaa 8,x
	bpl L14_e
;	a1 = 0;
	tsx
	clr 27,x
	clr 26,x
	clr 25,x
	clr 24,x
;
	jmp L14_f
L14_e:
;	else
;	a1 = PACK(sign ? SIGNBIT : 0, exp1, mant1 >> 4);
;		mant1	0-3,x
;		exp1	8-9,x
;		a1		24-27,x (uint32_t)
;		#define PACK(s, e, m)	((s) | (((uint32_t)(e)) << 23) | ((m) & 0x7FFFFFUL))
;
;	a1 = mant1>>4
	ldab 3,x
	stab 27,x
	ldab 2,x
	stab 26,x
	ldab 1,x
	stab 25,x
	ldab 0,x
	stab 24,x
;
	ldab #4
L3L_s1:
	lsr 24,x	
	ror 25,x
	ror 26,x
	ror 27,x
	decb
	bne L3L_s1
;
	ldab 25,x
	ldaa 9,x	; exp1
	lslb
	lsra
	rorb
	stab 25,x
	oraa 14,x	; sign
	staa 24,x
;
L14_f:
L13_f:
;	return (a1);
	ldaa 26,x
	ldab 27,x
	ldx 24,x
	stx @hireg
;
L0_r:
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	ins
	jmp __cleanup8
