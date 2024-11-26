	.setcpu 6800
	.code
	.export __divf
	.code
__divf:
;	a1	28-31,x
;	a2	24-27,x
;	uint32_t result; 0,x
;	uint32_t mask;	4,x
;	uint32_t mant1, mant2;	8,x 12,x
;	int exp;	16-17,x
;	uint32_t sign; 18-21,x
	sts @tmp
	ldab @tmp+1
	ldaa @tmp
	addb #234
	adca #255
	stab @tmp+1
	staa @tmp
	lds @tmp
	tsx
;	if (!a2) return 0x7FC00000UL;	// divide by 0
	ldaa 24,x       ; a2
	oraa 25,x
	oraa 26,x
	oraa 27,x
	bne L0L
;	clra			; a is already 0
	clrb
	ldx #$7FC0
	stx @hireg
	jmp L0_r
;	if (!a1) return 0;
L0L:
	ldaa 28,x       ; a1
	oraa 29,x
	oraa 30,x
	oraa 31,x
	bne L1_e
;	clra			; a is already 0
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L0_r
L1_e:
;	The calculation order has been changed for simplicity.
;	orig. exp = EXP(a1)-EXP(a2)+EXCESS;
;	exp = EXP(a2)
;		exp 16-17,x
	ldab 24,x
	ldaa 25,x
	asla
	rolb
	clra
	stab 17,x
	staa 16,x
;	D = EXP(a1)
	ldab 28,x	; a1
	ldaa 29,x
	asla
	rolb
	clra		; now D=EXP(a1)
	subb 17,x	; D=EXP(a1)-EXP(a2)
	sbca 16,x
;	exp += EXCESS;
	addb #126
	adca #0
	stab 17,x
	staa 16,x
;	sign = SIGN(a1) ^ SIGN(a2);
;			sign 18-21,x but only use 18,x
;			a1 28-31,x
;			a2 24-27,x 
	ldaa 24,x
	eora 28,x
	anda #$80
	staa 18,x
L2_e:
;	mant1 = MANT(a1);
;		mant1 8-11,x
;		MANT(x) (((x) & 0x007FFFFF) | 0x00800000)
	ldab 31,x
	stab 11,x
	ldab 30,x
	stab 10,x
	ldab 29,x
	orab #$80
	stab 9,x
	clr 8,x
;	mant2 = MANT(a2);
;		mant2 = 12-15,x
	ldab 27,x
	stab 15,x
	ldab 26,x
	stab 14,x
	ldab 25,x
	orab #$80
	stab 13,x
	clr 12,x
;	if (mant1 < mant2) {
;		The upper 8 bits are always 0, 
;			the comparison starts from the second byte and is calculated unsigned.
;		mant2 - mant1>0 ?
;	ldab 13,x	; already have
	cmpb 9,x
	bhi	L3_s	; mant2 > mant1
	bcs L3_e	; mant2 < mant1
	ldab 14,x
	cmpb 10,x
	bhi	L3_s	; mant2 > mant1
	bcs L3_e	; mant2 < mant1
	ldab 15,x
	cmpb 11,x
	bls L3_e	; mant2 <= mant1
L3_s:
;	mant1 <<= 1;
	asl 11,x
	rol 10,x
	rol 9,x
	rol 8,x
;	exp--;
	ldab 17,x
	ldaa 16,x
	subb #1
	sbca #0
	stab 17,x
	staa 16,x
;
L3_e:
;	mask = 0x01000000UL;
;		mask 4-7,x
	clrb
	stab 7,x
	stab 6,x
	stab 5,x
	ldaa #$01
	staa 4,x
;	result = 0;
;		result 0-3,x
	stab 3,x
	stab 2,x
	stab 1,x
	stab 0,x
;	The original program checks whether the mask is 0,
;	but this program shifts the mask to the right and checks whether the carry becomes 1.
;	This loop takes the most time. We need some ideas to speed it up.
;		Unrolling the loop obviously makes it faster, but it uses up memory.
;	do {
L4_c:
;	if (mant1 >= mant2) {
;		mant1 8-11,x
;		mant2 12-15,x
	ldab 8,x
	cmpb 12,x
	bhi	L5_s		; mant1 > mant2
	bcs	L5_e		; mant1 < mant2
	ldab 9,x
	cmpb 13,x
	bhi	L5_s		; mant1 > mant2
	bcs	L5_e		; mant1 < mant2
	ldab 10,x
	cmpb 14,x
	bhi	L5_s		; mant1 > mant2
	bcs	L5_e		; mant1 < mant2
	ldab 11,x
	cmpb 15,x
	bcs	L5_e		; mant1 < mant2
L5_s:
;	result |= mask;
;		result 0-3,x
;		mask 4-7,x
;		Since only 1 bit is set in mask, we can skip the process, but it won't be much faster.
	ldab 4,x
	orab 0,x
	stab 0,x
	ldab 5,x
	orab 1,x
	stab 1,x
	ldab 6,x
	orab 2,x
	stab 2,x
	ldab 7,x
	orab 3,x
	stab 3,x
;	mant1 -= mant2;
;		mant1 8-11,x
;		mant2 12-15,x
	ldab 11,x
	subb 15,x
	stab 11,x
	ldab 10,x
	sbcb 14,x
	stab 10,x
	ldab 9,x
	sbcb 13,x
	stab 9,x
	ldab 8,x
	sbcb 12,x
	stab 8,x
;
L5_e:
;	mant1 <<= 1;
	asl 11,x
	rol 10,x
	rol 9,x
	rol 8,x
;	mask >>=1
;		mask 4-7,x
	lsr	4,x
	ror 5,x
	ror 6,x
	ror 7,x
;
;	}while(mask);
	bcc L4_c
L4_b:
;	result +=1
;		result 0-3,x
	inc 3,x
	bne L4_b2
	inc 2,x
	bne L4_b2
	inc 1,x
	bne L4_b2
	inc 0,x
L4_b2:
;	exp++
;		exp 16-17,x
	inc 17,x
	bne L4_b3
	inc 16,x
L4_b3:
;	result >>= 1;
;		result 0-3,x
	lsr 0,x
	ror 1,x
	ror 2,x
	ror 3,x
;	result &= ~HIDDEN
;		HIDDEN 0x00800000
	ldab 1,x
	andb #$7F
	stab 1,x
;
;	if (exp >= 0x100)
;		exp 16-17,x
	ldaa 16,x
	cmpa #1
	blt L6_e
;	a1 = (sign ? SIGNBIT : 0) | INFINITY;
;	a1 = (sign ? 0x80000000UL: 0) | 0x78000000UL;
;		a1	28-31,x
;		sign 18-21,x only use 18,x
	clrb
	stab 31,x
	stab 30,x
	stab 29,x
	ldab 18,x
	orb #$78
	stab 28,x
	jmp L6_f
L6_e:
;	else if (exp < 0)
;		exp 16-17,x
	tsta
	bpl L7_e
;	a1 = 0;
	clra
	staa 31,x
	staa 30,x
	staa 29,x
	staa 28,x
	jmp L7_f
L7_e:
;	else
;	a1 = PACK(sign ? SIGNBIT : 0, exp, result);
;		a1	28-31,x
;		exp;	16-17,x
;		sign 18-21,x only use 18,x
;		result 0-3,x
	ldab 3,x
	stab 31,x
	ldab 2,x
	stab 30,x
	ldab 1,x
	ldaa 17,x
	lslb
	lsra
	rorb
	stab 29,x
	oraa 18,x
	staa 28,x
;
L7_f:
L6_f:
;	return a1;
	ldab 31,x
	ldaa 30,x
	ldx	28,x
	stx @hireg
;
L0_r:
	staa @tmp2
	stab @tmp2+1
	sts @tmp
	ldab @tmp+1
	ldaa @tmp
	addb #22
	adca #0
	stab @tmp+1
	staa @tmp
	lds @tmp
	ldab @tmp2+1
	ldaa @tmp2
	jmp __cleanup8
