	.setcpu 6800
	.code
	.export __castf_ul
	.code
__castf_ul:
	des
	des
;deref r 1205 0
; go via shortcut
;make local ptr off 4, rlim 252 noff 4
	tsx
	ldaa 6,x
	ldab 7,x
	ldx 4,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	ldaa #127
	ldab #255
	staa @hireg
	stab @hireg+1
	tba
; helper T_AND -> band
; gen_helpcall, invalidate_all()
	jsr __bandl
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	clra
	clrb
	staa @hireg
	stab @hireg+1
; gen_helpcall, invalidate_all()
	jsr __cceql
;
	jeq L1_e
	clra
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L0_r
L1_e:
	clra
	clrb
	staa @hireg
	stab @hireg+1
	ldab #24
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
;deref r 1205 0
; go via shortcut
;make local ptr off 4, rlim 252 noff 4
	tsx
	ldaa 10,x
	ldab 11,x
	ldx 8,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	clra
	ldab #23
; gen_helpcall, invalidate_all()
	jsr __shrul
	clra
	clr @hireg
	clr @hireg+1
; gen_helpcall, invalidate_all()
	jsr __minusl
	addb #126
	adca #0
	bcc X1
inc @hireg+1
	bne X1
	inc @hireg
X1:
;make local ptr off 0, rlim 254 noff 4294967292
	tsx
	stb 1,x
	sta 0,x
;
	pshb
	psha
	clra
	ldab #24
; gen_helpcall, invalidate_all()
	jsr __ccgteq
;
	jeq L2_e
	clra
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L0_r
L2_e:
;make local ptr off 0, rlim 254 noff 0
	tsx
	ldb 1,x
	lda 0,x
	pshb
	psha
	clra
	clrb
; gen_helpcall, invalidate_all()
	jsr __cclt
;
	jeq L3_e
;deref r 1205 0
; go via shortcut
;make local ptr off 4, rlim 252 noff 4
	tsx
	ldaa 6,x
	ldab 7,x
	ldx 4,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	clra
	ldab #127
	staa @hireg
	stab @hireg+1
	ldaa #255
	tab
; helper T_AND -> band
; gen_helpcall, invalidate_all()
	jsr __bandl
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	clra
	ldab #128
	staa @hireg
	stab @hireg+1
	clrb
; gen_helpcall, invalidate_all()
	jsr __orl
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
;make local ptr off 0, rlim 254 noff 0
	tsx
	ldb 5,x
	lda 4,x
	coma
	comb
	addb #1
	adca #0
; gen_helpcall, invalidate_all()
	jsr __shll
;
	jmp L0_r
L3_e:
;deref r 1205 0
; go via shortcut
;make local ptr off 4, rlim 252 noff 0
	tsx
	ldaa 6,x
	ldab 7,x
	ldx 4,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	clra
	ldab #127
	staa @hireg
	stab @hireg+1
	ldaa #255
	tab
; helper T_AND -> band
; gen_helpcall, invalidate_all()
	jsr __bandl
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	clra
	ldab #128
	staa @hireg
	stab @hireg+1
	clrb
; gen_helpcall, invalidate_all()
	jsr __orl
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
;make local ptr off 0, rlim 254 noff 0
	tsx
	ldb 5,x
	lda 4,x
; gen_helpcall, invalidate_all()
	jsr __shrul
;
L0_r:
	ins
	ins
	jmp __cleanup4
	.export __castf_u
__castf_u:
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 4294967294
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	jsr __castf_ul+0
;
L4_r:
	jmp __cleanup4
	.export __castf_uc
__castf_uc:
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 2
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	jsr __castf_ul+0
;
L5_r:
	jmp __cleanup4
	.export __castf_l
__castf_l:
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 2
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	clra
	clrb
	staa @hireg
	stab @hireg+1
; gen_helpcall, invalidate_all()
	jsr __cceql
;
	jeq L7_e
	clra
	clrb
	staa @hireg
	stab @hireg+1
;
	jmp L6_r
L7_e:
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 2
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	ldaa #128
	clrb
	staa @hireg
	stab @hireg+1
	clra
; helper T_AND -> band
; gen_helpcall, invalidate_all()
	jsr __bandl
; gen_helpcall, invalidate_all()
	jsr __booll
;
	jeq L8_e
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 2
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	jsr __negatef+0
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	jsr __castf_ul+0
; gen_helpcall, invalidate_all()
	jsr __negatel
;
	jmp L6_r
L8_e:
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 2
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	jsr __castf_ul+0
;
L6_r:
	jmp __cleanup4
	.export __castf_
__castf_:
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 2
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	jsr __castf_l+0
;
L9_r:
	jmp __cleanup4
	.export __castf_c
__castf_c:
;deref r 1205 0
; go via shortcut
;make local ptr off 2, rlim 252 noff 2
	tsx
	ldaa 4,x
	ldab 5,x
	ldx 2,x
	stx @hireg
	pshb
	psha
	ldaa @hireg+1
	psha
	ldaa @hireg
	psha
	jsr __castf_l+0
;
L10_r:
	jmp __cleanup4
