;
;	Add the constant following the call to X without
;	messing up D
;
;	jsr	__addxconst
;	.word	number_for_add
;
	.export __addxconst
	.code

__addxconst:
	pshb		; 0,x
	stx @tmp	; X where we can manipulate it
	tsx
	ldx 1,x		; get word's address
	ldab 1,x	; value to add
	addb @tmp+1
	stab @tmp+1
	ldab 0,x
	adcb @tmp
	stab @tmp	; X+word into @tmp
	tsx
	ldab 2,x	; get return address from stack
	addb #2		; calculate correct return address
	stab 2,x
	ldab 1,x
	adcb #0
	stab 1,x
	ldx @tmp	; get new X
	pulb
	rts
