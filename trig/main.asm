format PE GUI 4.0
entry start

; ----------------------
; Constants
; ----------------------

XRES equ 800
YRES equ 600


include 'win32a.inc'
include 'win.asm'
include 'graphic.asm'
include 'triangles.asm'
include 'line.asm'
include 'math.asm'
include 'fixedpointsincos.asm'

section '.code' code readable executable



;---------- INICIO
start:
	call GETWINDOW
	call mainloop
	jmp SYSEND


mainloop:
	call SYSCLS
	mov [DEST_BUFFER], SCREEN_BUFFER
	mov [DEST_W], SCREEN_W
	mov [DEST_H], SCREEN_H
	;ccall _draw_horizontal_line, 10, 10, 20, $FF00ff00
	;ccall _draw_quad, 0, 0, SCREEN_W, SCREEN_H,  $FF000000

	; loads mouse (x,y) into (ebx, eax)
	;mov eax, [SYSXYM]
	;mov ebx,eax
	;shr eax,16
	;and ebx,$ffff

	mov eax, [hspeed]
	add [x_pos], eax
	jle .flip_hspeed
	mov eax, SCREEN_W-16
	cmp [x_pos], eax
	jge .flip_hspeed
	jmp .end_flip_hspeed
	.flip_hspeed:
	neg [hspeed]
	.end_flip_hspeed:


	mov eax, [vspeed]
	add [y_pos], eax
	jle .flip_vspeed
	mov eax, SCREEN_H-16
	cmp [y_pos], eax
	jge .flip_vspeed
	jmp .end_flip_vspeed
	.flip_vspeed:
	neg [vspeed]
	.end_flip_vspeed:

	mov 	eax, -10
	ccall 	_abs, -10

	ccall _draw_sprite, spr_mario, [x_pos], [y_pos], 16, 16

	;;;;;;;;;;;;;;;;,

	xor ecx, ecx
	.theloop:
	mov eax, ecx
	shl eax, 8
	push ecx
	call cos

	; 1 0000 0000 0000 0000
	shr eax, 9
	;             1000 0000
	add eax, $80
	;           1 0000 0000
	and eax, $1FF

	mov ebx, 50
	imul ebx
	mov ebx, $FF
	idiv ebx
	add eax, 50
	

	pop ecx
	push ecx
	ccall _draw_pixel, ecx, eax, $FFFF0000
	pop ecx

	mov eax, ecx
	shl eax, 8
	push ecx
	call sin

	shr eax, 9
	add eax, $80
	and eax, $1FF
	

	pop ecx
	push ecx
	ccall _draw_pixel, ecx, eax, $FF00FF00


	pop ecx
	inc ecx
	cmp ecx, 400
	jle .theloop



	;ccall _draw_line, 0, 0, [x_pos], [y_pos], $FFFFFFFF

	mov [DEST_BUFFER], SYSFRAME
	mov [DEST_W], XRES
	mov [DEST_H], YRES
	ccall _copy_buffer, SCREEN_BUFFER, SCREEN_W, SCREEN_H, 2

	call SYSREDRAW
	call SYSUPDATE
	cmp [SYSKEY],1
	jne mainloop
	ret


section '.data' data readable writeable
	spr_mario	file 'spr_mario.bin':4
	x_pos       dd 0
	hspeed      dd 3
	y_pos       dd 0 
	vspeed      dd 1 
	i			dd ?



