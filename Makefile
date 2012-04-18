all: rom1.nes

rom1.raw: rom1.asm
	acme -f plain -o $@ $<

rom1.chr.raw: rom1.chr.asm
	acme -f plain -o $@ $<

rom1.nes.hdr.raw: rom1.nes.hdr.asm
	acme -f plain -o $@ $<

rom1.nes: rom1.raw rom1.chr.raw rom1.nes.hdr.raw
	cat rom1.nes.hdr.raw rom1.raw rom1.chr.raw >$@

clean:
	rm -fv *.nes *.o65 *.fns *.deb *.raw
