
*= $8000

.start2		jmp	.start2

*= $c000

.start		jmp	.start2

*= $fffa
		!word	.start		; NMI
		!word	.start		; Power on/reset
		!word	.start		; BRK handler

; == 32K

