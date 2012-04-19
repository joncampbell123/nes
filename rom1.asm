
; our use of NES RAM: indirect temp
INDIRECT_TEMP = $FE

; our use of NES RAM: video output
PUTS_PAGE = $200		; HI:LO 16-bit address puts will write to
PUTS_OFFSET = $201
PUTS_SRC_PAGE = $202		; HI:LO 16-bit address puts reading will read from
PUTS_SRC_OFFSET = $203
PUTS_LINE_OFFSET = $204		; LO 8-bit address that is the start of line, on newline, +32 is added and then loaded into OFFSET
PUTS_REP_COUNT = $205

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

; clear the screen
		lda	#$21		; Y:X = $2000 (row = 0 col 0)
		sta	PUTS_PAGE
		lda	#$04
		sta	PUTS_OFFSET
		lda	#$80		; 128 x 8 writes = 1K
		sta	PUTS_REP_COUNT
.clearscreen_loop:
		pha			; SAVE A
		jsr	.wait_for_vblank; wait for retrace due to fucked up PPU design
		lda	#$41		; load A = what to write
		jsr	.puts_write	; first PPU write to get things started
		sta	$2007		; blast the next 8
		sta	$2007
		sta	$2007
		sta	$2007
		sta	$2007
		sta	$2007
		sta	$2007
		lda	PUTS_OFFSET
		clc	
		adc	#$07
		sta	PUTS_OFFSET
		lda	PUTS_PAGE
		adc	#$00
		sta	PUTS_PAGE
		pla			; RESTORE A
		clc
		sbc	#$01		; A--
		bne	.clearscreen_loop

; set up printout
		lda	#$21		; Y:X = $2104 (row = 4 col 4)
		sta	PUTS_PAGE
		lda	#$04
		sta	PUTS_OFFSET
		sta	PUTS_LINE_OFFSET
		lda	#(test_string >> 8)
		sta	PUTS_SRC_PAGE
		lda	#(test_string & 0xFF)
		sta	PUTS_SRC_OFFSET

; print!
.printloop:	jsr	.puts_read	; -> A = byte read from PUTS_SRC
		beq	.printloop_end	; break loop if zero
		jsr	.puts_write_fmt	; write A to PUTS_PAGE:PUTS_OFFSET

; make sure the "pan" register points at (0,0)
; if FCEUX emulation is any indication whatever PPU address we write to becomes where the PPU draws from?!?
		lda	#$00
		sta	$2005
		sta	$2005

		jsr	.wait_for_vblank; wait for vblank

		jmp	.printloop
.printloop_end:

; stop
.stophere	jmp	.stophere

; data
test_string	!text	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",10
		!text	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",10
		!text	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",10
		!byte	0

*= $c000

.start		jmp	.start2

; library

.puts_read:
;   INPUT: PUTS_SRC_PAGE:PUTS_SRC_OFFSET
;   OUTPUT: A = byte read from that address
;           X = 0
		lda	PUTS_SRC_OFFSET			; copy offset to INDIRECT_TEMP
		sta	INDIRECT_TEMP
		clc
		adc	#$01				; add +1 to the offset
		sta	PUTS_SRC_OFFSET			; write back to SRC_OFFSET
		lda	PUTS_SRC_PAGE
		sta	INDIRECT_TEMP+1
		adc	#$00				; add 0 + carry to page
		sta	PUTS_SRC_PAGE			; write back to SRC_PAGE
		ldx	#$00
		lda	(INDIRECT_TEMP,x)		; load 16-bit address we copied to $FE
		rts

.puts_write_fmt:
;   INPUT: A = what to write
;          PUTS_PAGE:PUTS_OFFSET = where to write
;   If A is newline, then cursor jumps to next line
		cmp	#$0A				; ASCII '\n'?
		beq	.puts_newline
		jmp	.puts_write			; proceed with print

;   INPUT: PUTS_PAGE:PUTS_OFFSET = where to write
;          PUTS_LINE_OFFSET = basis of line
;   OUTPUT: PUTS_LINE_OFFSET += 32, PUTS_OFFSET = PUTS_LINE_OFFSET
.puts_newline:
		pha
		clc

		lda	PUTS_LINE_OFFSET		; load line offset
		adc	#$20				; += 32
		sta	PUTS_LINE_OFFSET		; write back
		sta	PUTS_OFFSET			; and to offset too

		lda	PUTS_PAGE			; load page
		adc	#$00				; add 0+carry
		sta	PUTS_PAGE			; write back
		
		pla
		rts

.puts_write
;   INPUT: A = what to write
;          PUTS_PAGE:PUTS_OFFSET = where to write
;
;   note we don't write to CPU memory, we write to PPU memory
		pha

		lda	PUTS_OFFSET			; load offset
		pha					; save on stack
		clc					; make sure carry is clear
		adc	#$01				; add +1 to offset
		sta	PUTS_OFFSET			; write back

		lda	PUTS_PAGE			; load page
		pha					; save on stack
		adc	#$00				; add +0+carry to page
		sta	PUTS_PAGE

		pla					; restore page
		sta	$2006				; write page to PPU
		pla					; restore offset
		sta	$2006				; write offset to PPU

		pla					; restore A
		sta	$2007
		rts

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

