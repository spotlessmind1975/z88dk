; Substitute for the z80 sbc hl,sp instruction
; CPU   Min T Max T
; 8080  156   156
; 8085  154   154
; gbz80 232   232
; r2ka    4     4
; z180   10    10
; z80    15    15
; z80n   15    15

        SECTION code_l_sccz80
        PUBLIC  __z80asm__sbc_hl_sp

__z80asm__sbc_hl_sp:
        push    bc
        ld      b, a
        push    de
        ex      de, hl                  ; subtrahed to de

        push    af
        ld      hl, sp+8                ; minuend to hl, compensate for return address, DE and BC in stack
        pop     af

        ld      a, e
        sbc     a, l
        ld      e, a

        ld      a, d
        sbc     a, h
        ld      d, a

        ex      de, hl
        pop     de
        ld      a, b
        pop     bc
        ret
