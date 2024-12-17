
; Hello World example

; ROM routine for character output
CHPUT:  equ 000A2h
GRPUT:  equ 0008dh

; addresses
XCRD1: equ 0FCB3h
XCRD2: equ 0FCB7h
YCRD1: equ 0FCB5h
YCRD2: equ 0FCB9h

FORCLR:	equ 0F3E9h
BAKCLR:	equ 0F3EAh
BDRCLR:	equ 0F3EBh

	org 0x4000
        
; MSX cartridge header @ 0x4000 - 0x400f
	dw 0x4241
        dw start
        dw start
        dw 0
        dw 0
        dw 0
        dw 0
        dw 0

; initialize and print message
start:
	ld a, 2
        call Screen

	ld a, 15
        ld b, 2
        ld c, 1
        call colors
     
	ld b, 10
mainloop:
	ld hl, msg
    	call gputs
    	djnz mainloop
stop:   jr stop; loop forever

; DATA
; ASCII message + CR LF
msg:    defm "Hello, world!",13,10,0

; SUBS

puts:			; print 0-terminated string in HL
    ld a,(hl)
    or a
    ret z
    call CHPUT      ; displays one character in A
    inc hl
    jr puts
    
; Подпрограмма установки любого режима VDP
; вход: А <- номер режима

Screen:	ld	(0FCAFh),a	; поместить в SCRMOD
	ld	ix,005Fh
	jp	MAINRM		; вызвать из MAIN-ROM
        
; Вызов подпрограммы из MAIN-ROM
; вход: IX <- адрес подпрограммы

MAINRM:	ld	iy,(0FCC0h)	; номер слота MAIN-ROM
	jp	001Ch
    
gputs:			; print 0-terminated string in HL
    ld a,(hl)
    or a
    ret z
    call GRPUT      ; displays one character in A
    inc hl
    jr gputs


PrintXY: 		; HL -> msg, BC - X, DE - Y
    ld (XCRD1), BC
    ld (XCRD2), BC
    ld (YCRD1), DE
    ld (YCRD2), DE
    jr gputs
    


colors: 		;set colors from A,B,C
        ld hl,BAKCLR		; Loads BAKCLR sys variable in HL
        ld (hl),B		; Loads the value from B into the position pointed by HL
        ld hl,BDRCLR		; Loads BDCLR sys variable in HL
        ld (hl),C		; Loads the value from C into the position pointed by HL
color: 			;set color from A
	ld hl,FORCLR		; Loads FORCLR sys variable in HL
        ld (hl),A		; Loads the value from A into the position pointed by HL
        ret