;;Encrypt	your	computer	in	MBR!
org	7c00h				;Code	execute	from	0x7c00
OffsetOfDecoder	equ	8100h
Start:
				mov	ax,cs				;initialize
				mov	ds,ax				;data	segment
				mov	bp,SysName
				mov	ax,ds			
				mov	es,ax
				mov	cx,LenName
				mov	ax,1301h			;AH=13h--Function,AL=01h--end
				mov	bx,0007h
				mov	dh,0				;line0
				mov	dl,0				;column:0
				int	10h					;BIOS-10h interrupt:show the string
				mov	bp,Note2
				mov	cx,LenNote2
				mov	dh,1
				mov	dl,0
				int	10h
				mov	bp,Note3
				mov	cx,LenNote3
				mov	dh,2
				mov	dl,0
				int	10h
				xor	cx,cx
				xor	bx,bx

getInput:
	xor	ax,ax
	int	0x16
	

				
				
	cmp	al,0x8		;backspace
	je	backspace
	cmp	al,0x0d		;enter
	je	verification
	
	
	mov	ah,2
	mov	[bx],al
	mov	[bx+1],ah
	add	bx,2
	inc	cx
	
	mov	ah,0eh
	mov	al,'*'
	
	int	10h
	
	jmp	getInput

backspace:			;revert	former	operation
	cmp	bx,0
	je	bxiszero
	sub	bx,2
	
				mov	ah,0eh
	int	10h
	
	bxiszero:
	cmp	cx,0
	je	cxiszero
	dec	cx
	cxiszero:
	xor	ax,ax
	mov	[bx],ax
	jmp	getInput


verification:
	mov	ax,cs
	mov	es,ax
	xor	bx,bx
	mov	si,Password


compare:
	mov	al,[ds:bx]
	mov	ah,[es:si]
	cmp	ah,0
	je	After
	cmp	al,ah
	jne	Error
	dec	cx
	add	bx,2
	inc	si
	jmp	compare
	After:
        cmp	cx,0
        jne	Error

        jmp	Success

Error:
	xor	cx,cx
	xor	bx,bx
	xor	ax,ax
	
	mov	ax,0xffff
	push	ax
	mov	ax,0
	push	ax
	retf

Success:
				mov	ax,cs
				mov	es,ax
				mov	bx,OffsetOfDecoder
				mov	ah,2	;sector_read_code
				mov	al,1	;one	sector
				mov	dl,80h	;Harddrive
				mov	dh,1	;citou
				mov	ch,0	;cidao
				mov	cl,40	;Sector	of	the	MBR	loader
				int	13h
				jmp	OffsetOfDecoder
				

;;;Data	Region
SysName:
	db	"PC	Secure	System	--by:Haoqing	Deng"
LenName	equ	($-SysName)
Note2:
	db	"Please	input	your	password	to	load	the	MBR	program."
LenNote2	equ	($-Note2)
Note3:
	db	"Password:"
LenNote3	equ	($-Note3)
Password:
	db	'passwd',0




;;;End	of	data	region


times	440-($-$$)	db	0 ;Insert into the rest area of the 

