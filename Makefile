all: rom1.nes

rom1.nes: rom1.asm
	nesasm3 -s rom1.asm

clean:
	rm -v *.nes *.o65 *.fns *.deb
