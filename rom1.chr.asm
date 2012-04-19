
; DEPRECATED

BYTES_PER_TILE = 16

*= $0000

*= BYTES_PER_TILE * 'A'
		!byte	$10	; 00010000
		!byte	$38	; 00111000
		!byte	$6C	; 01101100
		!byte	$C6	; 11000110
		!byte	$FE	; 11111110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$00	; 00000000

		!byte	$10	; 00010000
		!byte	$38	; 00111000
		!byte	$6C	; 01101100
		!byte	$C6	; 11000110
		!byte	$FE	; 11111110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$00	; 00000000

*= BYTES_PER_TILE * 'B'
		!byte	$FC	; 11111100
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$FC	; 11111100
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$FC	; 11111100
		!byte	$00	; 00000000

		!byte	$FC	; 11111100
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$FC	; 11111100
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$FC	; 11111100
		!byte	$00	; 00000000

*= BYTES_PER_TILE * 'C'
		!byte	$7C	; 01111100
		!byte	$C6	; 11000110
		!byte	$C0	; 11000000
		!byte	$C0	; 11000000
		!byte	$C0	; 11000000
		!byte	$C6	; 11000110
		!byte	$7C	; 01111100
		!byte	$00	; 00000000

		!byte	$7C	; 01111100
		!byte	$C6	; 11000110
		!byte	$C0	; 11000000
		!byte	$C0	; 11000000
		!byte	$C0	; 11000000
		!byte	$C6	; 11000110
		!byte	$7C	; 01111100
		!byte	$00	; 00000000

*= BYTES_PER_TILE * 'D'
		!byte	$FC	; 11111100
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$FC	; 11111100
		!byte	$00	; 00000000

		!byte	$FC	; 11111100
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$C6	; 11000110
		!byte	$FC	; 11111100
		!byte	$00	; 00000000

*= $3ffe
		!word	0

; == 16K

