all: rom1.nes

rom1.raw: rom1.asm
	acme -f plain -o $@ $<

rom1.nes.hdr.raw: rom1.nes.hdr.asm
	acme -f plain -o $@ $<

rom1.nes: rom1.raw rom1.nes.hdr.raw
	cat rom1.nes.hdr.raw rom1.raw >$@
	dd if=rom1.chr.bitmap bs=16 skip=1 >>$@

clean:
	rm -fv *.nes *.o65 *.fns *.deb *.raw *~

