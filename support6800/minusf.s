	.setcpu 6800
	.code
	.export __negatef
	.code
__negatef:
	tsx
	ldaa 2,x
	eora #$80
	staa 2,x
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
;
L0_r:
	jmp __cleanup4
;
	.export __minusf
;	return (a2-a1);
__minusf:
;	(return address 0-1,x)
;	uint32_t	a1	2-5,x
;	uint32_t	a2	6-9,x
	tsx
;	push -a1
	ldab 5,x
	pshb
	ldab 4,x
	pshb
	ldab 3,x
	pshb
	ldab 2,x
	eorb #$80
	pshb
;	push a2
	ldab 9,x
	pshb
	ldab 8,x
	pshb
	ldab 7,x
	pshb
	ldab 6,x
	pshb
;
	jsr __plusf
L1_r:
	jmp __cleanup8
