		.setcpu 6800
;	.zp
;	.export hireg
;	.export zero
;	.export	one
;
		.org	$00e0
hireg:	.word	0
zero:	.byte	0	; overlaps 1
one:	.word	0
;
;	.export tmp
;	.export tmp2
;	.export tmp3
;	.export tmp4
;	.export tmp5
;
tmp:	.word	0
tmp2:	.word	0
tmp3:	.word	0
tmp4:	.word	0
tmp5:	.word	0
savesp:	.word	0


	.code ; (at 0x4000)
start:
	sts	@savesp
	lds #$8FFF
	clrb
	clra
	stab @zero+1
	staa @zero
	incb
	stab @one+1
	staa @one
	psha	; dummy argc
	pshb
	psha	; dummy argv
	pshb
	jsr	_main
	; return and exit (value is in XA)
	lds	@savesp
	rts

	.export _printchar
	.export _putch
	.export _getch
	.export _crt_clear
_putch:
_printchar:
	tsx
	ldaa 3,x
	jsr	$F015
	ldx 0,x
	ins
	ins
	ins
	ins
	jmp 0,x
_getch:
	jsr $F012
	tab
	clra
	rts
_crt_clear:
	ldx #$100
	clrb
c1:
	stb 0,x
	inx
	cpx #$400
	bne c1
	rts
