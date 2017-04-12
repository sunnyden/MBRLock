;;Encrypt your computer in MBR!
org 8100h				;Code execute from 0x7c00
OffsetOfMBR equ 7c00h
Start:
    mov ax,cs				;initialize
    mov ds,ax				;data segment
    mov bp,SysName
    mov ax,ds			
    mov es,ax
    mov cx,LenName
    mov ax,1301h			;AH=13h--Function,AL=01h--end
    mov bx,0007h
    mov dh,4				;line0
    mov dl,0				;column:0
    int 10h					;BIOS-10h function:show the string
    xor ax,ax
    int 0x16


    ;mbr loader
    mov ax,cs
    mov es,ax
    mov bx,OffsetOfMBR
    mov ah,2
    mov al,1
    mov dl,80h
    mov dh,1
    mov ch,0
    mov cl,41 ;Sector of the MBR
    int 13h
    jmp OffsetOfMBR
    

;;;Data Region

SysName:
	db "Password correct! Press any key to continue.."
LenName equ ($-SysName)





;;;End of data region


times 512-($-$$) db 0	;insert 0 into the rest areas
;db 0x55,0xaa			;insert AA55 At the end of the MBR record to mark it as an valid MBR record
;;0xFE~0x00
;;In the next 512k Sector is the origin MBR record
;;0xFE+0x7C00
