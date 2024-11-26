;
;	Multiply 2-5,x by hireg:d
;
;	2-5,x	Argument
;
	.export __mull
	.export __mulul

	.code
__mull:
__mulul:
	stab @tmp+1	; D into tmp to free registers hireg:tmp is now the value
	staa @tmp
	clra
	psha		; Work space to zero
	psha		; We will iteratively add to this for each 1 bit
	psha
	psha		; workspace is 0-3,x argument is now 6-9,x
	tsx
	ldaa @tmp+1
	beq	__mull_4
	ldab 9,x
	beq	__mull_1
	jsr	__mul88
	stab 3,x
	staa 2,x
__mull_1:
	ldaa @tmp+1
	ldab 8,x
	beq __mull_2
	jsr	__mul88
	addb 2,x
	stab 2,x
	adca 1,x
	staa 1,x
__mull_2:
	ldaa @tmp+1
	ldab 7,x
	beq __mull_3
	bsr __mul88
	addb 1,x
	stab 1,x
	adca 0,x
	staa 0,x
__mull_3:
	ldaa @tmp+1
	ldab 6,x
	beq	__mull_4
	bsr	__mul88
	addb 0,x
	stab 0,x
__mull_4:
	ldaa @tmp
	beq	__mull_8
	ldab 9,x
	beq	__mull_5
	bsr	__mul88
	addb 2,x
	stab 2,x
	adca 1,x
	staa 1,x
	ldaa #0
	adca 0,x
	staa 0,x
__mull_5:
	ldaa @tmp
	ldab 8,x
	beq __mull_6
	bsr __mul88
	addb 1,x
	stab 1,x
	adca 0,x
	staa 0,x
__mull_6:
	ldaa @tmp
	ldab 7,x
	beq __mull_8
	bsr __mul88
	addb 0,x
	stab 0,x
__mull_8:
	ldaa @hireg+1
	beq __mull_12
	ldab 9,x
	beq __mull_9
	bsr __mul88
	addb 1,x
	stab 1,x
	adca 0,x
	staa 0,x
__mull_9:
	ldaa @hireg+1
	ldab 8,x
	beq __mull_12
	bsr __mul88
	addb 0,x
	stab 0,x
__mull_12:
	ldaa @hireg
	beq	__mull_e
	ldab 9,x
	beq	__mull_e
	bsr __mul88
	addb 0,x
	stab 0,x
__mull_e:
	pula
	staa @hireg
	pula
	staa @hireg+1
	pula
	pulb
	jmp __pop4

;
;	D = A*B
;
__mul88:
	stab	@tmp2+1
	staa	@tmp2
	stx		@tmp3
	ldx		#8
	clra
	clrb
mul88_1:
	aslb
	rola
	rol		@tmp2
	bcc		mul88_2
	addb	@tmp2+1
	adca	#0
mul88_2:
	dex
	bne		mul88_1
	ldx		@tmp3
	rts
