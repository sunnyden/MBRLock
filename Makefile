MBR_BOOT_DEVICE=/dev/nvme0n1
all:asm mbr_record
	cat mbr_encrypt ptable mbr_rest mbr_decrypt mbr_0>product.mbr
asm:
	nasm mbr_encrypt.asm
	nasm mbr_decrypt.asm

mbr_record:
	dd if=$(MBR_BOOT_DEVICE) of=./mbr_0 bs=512 skip=0 count=1
	dd if=./mbr_0 of=./ptable  bs=1 skip=440
	dd if=$(MBR_BOOT_DEVICE) of=./mbr_rest bs=512 skip=1 count=101
clean:
	rm mbr_encrypt ptable mbr_rest mbr_decrypt mbr_0 product.mbr
