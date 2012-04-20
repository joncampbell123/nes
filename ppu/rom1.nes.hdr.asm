
*= $0000

		!text		"NES"
		!byte		$1a
		!byte		$02		; number of PRG-ROM blocks
		!byte		$01		; number of CHR-ROM blocks
		!byte		$00,$00		; control: horizontal mirroring, no SRAM
		!byte		$00,$00,$00,$00,$00,$00,$00,$00 ; filler

