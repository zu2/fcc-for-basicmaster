        .setcpu 6800
        .code
        .export _plot
        .code
_plot:
        tsx     ; x     2,x
;               ; y     3,x
;               ; z     4,x
;       while (y>47) y -= 48;
;make local ptr off 9, rlim 255 noff 9
        lda 3,x
L1_c:
        suba #48
        bcc L1_c
		inca
		nega			; AccA = 47-y
;       x &= 63
        ldb 2,x
;		andb #<63		; AccB = x&63	; Bits 7 and 6 disappear with aslb, no need to mask them.
;
;       p = (((47-y)>>1)*32) +(x>>1) + 0x0100;
        aslb
        aslb
        lsra
        lsra
        rorb
        lsra
        rorb
        lsra
        rorb
        inca			; + 0x0100
        stb @tmp2+1
        sta @tmp2
;       c = *p
        ldx @tmp2
        ldb 0,x
        cmpb #16
        bcs L4_e
        clrb
L4_e:
;       c = c*11 & 0x0f
        tba
        asla
		aba				; AccA = c*3
        asla
        asla			; AccA = c*12
		sba				; AccA = c*11
        anda #$0f
        staa @tmp       ; now @tmp = c's bit pattern
        tsx
        clra
        lsr 3,x			; y&1 == 0 ?
        adca #1         ; if (y&1)==0  AccA=1 else AccA=2
        lsr 2,x			; x&1 == 0 ?
        bcc L1_2
        asla
        asla			; AccA <<= 2
L1_2:					; now AccA = mask
        ldab 4,x        ; z
        bne L5_e
        coma
        anda @tmp		; if(z==0) AccA = ~AccA & @tmp
        bra L6_f
L5_e:
        incb
        bne L6_e
        eora @tmp		; else if(z==-1) AccA ^= @tmp
        bra L6_f
L6_e:
        ora @tmp		; else AccA |= @tmp
L6_f:
;       *p = c*3 & 0x0f;
        tab
        asla
        aba
        anda #$0f
        ldx @tmp2
        staa 0,x
        tsx
        ldx 0,x
        ins
        ins
        ins
        ins
        ins
        jmp 0,x
