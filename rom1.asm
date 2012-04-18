
*= $8000

.start2
; make some noise
		lda	#$01		; square 1
		sta	$4015
		lda	#$08		; period low
		sta	$4002
		lda	#$02		; period high
		sta	$4003
		lda	#$bf		; volume
		sta	$4000

		jsr	.wait_for_vblank

		lda	#$28		; name table at $2000 not vertical write sprite pattern at $1000 screen pattern at $0000 sprite 8x16
		sta	$2000		; write PPU control register 1

		lda	#$0E		; no image masking, show sprites in left 8 cols, screen enable, bgcolor=black
		sta	$2001		; write PPU control register 2

; load grayscale palette
		lda	#$0D		; PPU[0] = black
		ldy	#$00
		jsr	.write_ppu_palette
		lda	#$00		; PPU[1] = gray
		ldy	#$01
		jsr	.write_ppu_palette
		lda	#$10		; PPU[2] = lt-gray
		ldy	#$02
		jsr	.write_ppu_palette
		lda	#$20		; PPU[3] = white
		ldy	#$03
		jsr	.write_ppu_palette

; write to VRAM
		lda	#$41		; the letter 'A'
		ldy	#$21
		ldx	#$04		; to $2104 (name table #0) 4th row 4th col
		jsr	.write_ppu
		lda	#$42		; the letter 'B'
		sta	$2007		; at this point the next write auto-increments the address

; now make sure the screen has scrolled correctly
		lda	#$00
		sta	$2005
		sta	$2005

; stop
.stophere	jmp	.stophere

*= $c000

.start		jmp	.start2

; library
.write_ppu
;   INPUT
;       A = what to write
;       Y:X = upper:lower 8 bits of address
		sty	$2006
		stx	$2006
		sta	$2007
		rts

.write_ppu_palette
;   INPUT
;       A = what to write
;       Y = lower 8 bits of PPU register to write
		pha
		lda	#$3F
		sta	$2006
		pla
		sty	$2006
		sta	$2007
		rts

.wait_for_vblank
		pha
.wait_for_vblank_still
		lda	$2002
		bpl	.wait_for_vblank_still
		pla
		rts

.nmi		rti

.brk		rti

*= $fffa
		!word	.nmi		; NMI
		!word	.start		; Power on/reset
		!word	.brk		; BRK handler

; == 32K

