	.setcpu 6800
	.code
	.export __mulf
	.code
__mulf:
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
;	if (!a1 || !a2) return (0);
	tsx
	ldaa 16,x	; a1
	oraa 17,x
	oraa 18,x
	oraa 19,x
	beq L0L
	ldaa 12,x	; a2
	oraa 13,x
	oraa 14,x
	oraa 15,x
	bne L1_e
L0L:
	clra
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L0_r
L1_e:
;	sign = (a1 ^ a2) & SIGNBIT;
;;		sign 6-9,x but use only  6,x
	ldaa 16,x	; a1
	eora 12,x	; a2
	anda #$80
	staa 6,x
;	exp = EXP(a1) - EXCESS;
	ldab 16,x	; a1
	ldaa 17,x
	asla
	rolb
	clra
	subb #126
	sbca #0
	stab 5,x
	staa 4,x
;	exp += EXP(a2);
	ldab 12,x	; a2
	ldaa 13,x
	asla
	rolb
	clra
	addb 5,x
	adca 4,x
	stab 5,x
	staa 4,x
;	a1 = MANT(a1);
	clr	16,x
	ldaa 17,x
	oraa #$80
	staa 17,x
;	a2 = MANT(a2);
	clr	12,x
	ldaa 13,x
	oraa #$80
	staa 13,x
;	result = (a1 >> 8) * (a2 >> 8);
;		(a1>>8)
;	ldab 18,x
;	pshb
;	ldaa 17,x
;	psha
;		(a2>>8)
;	ldab 14,x
;	ldaa 13,x
;	jsr	__mul
;		(a1>>8)
	ldab 18,x
	pshb
	ldab 17,x
	pshb
	ldab 16,x
	pshb
	clra
	psha
;		(a2>>8)
	staa @hireg
	ldaa 12,x
	staa @hireg+1
	ldab 14,x
	ldaa 13,x
;		*
	jsr __mull
;		result = ...
	tsx
	stab 3,x
	staa 2,x
	ldaa @hireg+1
	staa 1,x
	ldaa @hireg
	staa 0,x
;	result += ((a1 & 0xFFUL) * (a2 >> 8)) >> 8;
;;		(a1 & 0xFFUL)
	ldab 19,x
	pshb
	clra
	psha
	psha
	psha
;;		(a2 >> 8)
	staa @hireg
	ldaa 12,x
	staa @hireg+1
	ldab 14,x
	ldaa 13,x
	jsr __mull
;	result += (...) >> 8
	tsx
	adda 3,x
	staa 3,x
	ldaa 2,x
	adca @hireg+1
	staa 2,x
	ldaa 1,x
	adca @hireg
	staa 1,x
	ldaa 0,x
	adca #0
	staa 0,x
;	result += ((a2 & 0xFFUL) * (a1 >> 8)) >> 8;
;		(a2 & 0xFFUL)
;;		result 0-3,x
;;		a1 16-19,x
;;		a2 12-15,x
	ldab 15,x
	pshb
	clra
	psha
	psha
	psha
;		(a1 >> 8)
	staa @hireg
	ldaa 16,x
	staa @hireg+1
	ldab 18,x
	ldaa 17,x
	jsr __mull
;	result += (...) >> 8
	tsx
	adda 3,x
	staa 3,x
	ldaa 2,x
	adca @hireg+1
	staa 2,x
	ldaa 1,x
	adca @hireg
	staa 1,x
	ldaa 0,x
	adca #0
	staa 0,x
;	result += 0x40;
	ldab 3,x
	addb #64
	stab 3,x
	ldab 2,x
	adcb #0
	stab 2,x
	ldab 1,x
	adcb #0
	stab 1,x
	ldab 0,x
	adcb #0
	stab 0,x
;	if (result & SIGNBIT) {
	bpl	L2_e
;	result += 0x40; result >>= 8;
    ldab 3,x
    addb #64
    ldab 2,x
    adcb #0
    stab 3,x
    ldab 1,x
    adcb #0
    stab 2,x
    ldab 0,x
    adcb #0
    stab 1,x
	clr 0,x
	bra L2_f
L2_e:
;	} else {
;	result >>= 7;
	ldaa 3,x
	asla
	ldaa 2,x
	rola
	staa 3,x
	ldaa 1,x
	rola
	staa 2,x
	ldaa 0,x
	rola
	staa 1,x
	ldaa #0
	rola
	staa 0,x
;	exp--;
	ldb 5,x
	lda 4,x
	addb #255
	adca #255
	stb 5,x
	sta 4,x
;
L2_f:
;	result &= ~HIDDEN;
	ldab 1,x
	andb #127
	stab 1,x
;	if (exp >= 0x100)
	ldaa 4,x
	cmpa #1
	blt	L3_e
;	a1 = (sign ? SIGNBIT : 0) | INFINITY;
;;	a1 = (sign ? 0x80000000UL: 0) | 0x78000000UL;
;;		sign 6-9,x
	clrb
	stab 19,x
	stab 18,x
	stab 17,x
	ldab 6,x
	orb #$78
	stab 16,x
	jmp L3_f
L3_e:
;	else if (exp < 0)
;		a has 4,x
	tsta
	bpl	L4_e
;	a1 = 0;
	clra
	staa 19,x
	staa 18,x
	staa 17,x
	staa 16,x
	jmp L4_f
L4_e:
;	else
;	a1 = PACK(sign ? SIGNBIT : 0, exp, result);
;;	a1 = PACK(sign ? 0x80000000UL : 0, exp, result);
;;	a1 16,x
;;	sign 6,x
;;	exp 4-5,x
;;	result 0-3,x
	ldab 3,x
	stab 19,x
	ldab 2,x
	stab 18,x
	ldab 1,x
	ldaa 5,x
	lslb
	rora
	rorb
	stab 17,x
	oraa 6,x
	staa 16,x
L4_f:
L3_f:
	ldaa 18,x
	ldab 19,x
	ldx 16,x
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
	jmp __cleanup8
