; WYZ player
;
; Hardware output routine for MSX
;
;

	SECTION	code_psg

	PUBLIC	asm_wyz_hardware_out

	EXTERN	asm_wyz_PSG_REG
	EXTERN	asm_wyz_PSG_REG_SEC
	EXTERN	asm_wyz_ENVOLVENTE_BACK


asm_wyz_hardware_out:
    LD      A,(asm_wyz_PSG_REG+13)
    AND     A           ;ES CERO?
    JR      Z,NO_BACKUP_ENVOLVENTE
    LD      (asm_wyz_ENVOLVENTE_BACK),A     ;08.13 / GUARDA LA ENVOLVENTE EN EL BACKUP
    XOR     A
NO_BACKUP_ENVOLVENTE:
    ld      b,a
    LD      HL,asm_wyz_PSG_REG_SEC+7
    ld      a,@00111111
    and     (hl)
    or      @01000000
    ld      (hl),a
    ld      a,b
    LD      HL,asm_wyz_PSG_REG_SEC
    LD      BC,$41
LOUT:
    OUT     (C),A
    DEC     C
    OUTI
    LD      B,0
    INC     C
    INC     A
    CP      13
    JR      NZ,LOUT
    OUT     (C),A
    LD      A,(HL)
    AND     A
    RET     Z
    DEC     C
    OUT     (C),A
    XOR     A
    LD      (asm_wyz_PSG_REG_SEC+13),A
    LD      (asm_wyz_PSG_REG+13),A
    RET
