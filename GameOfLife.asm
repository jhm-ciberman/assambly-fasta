;-------------------------------------
; Fundamentos de arquitectura de computadoras
; Inteface Basica con Windows
; PHREDA - FASTA 2013
;-------------------------------------
format PE GUI 4.0
entry start

;XRES equ 400
;YRES equ 400
XRES equ 640
YRES equ 480
;XRES equ 1024 ;YRES equ 768
;XRES equ 1280 ;YRES equ 800

include 'win32a.inc'

section '.code' code readable executable

start:
	invoke	GetModuleHandle,0
	mov	[hinstance],eax
	invoke	LoadIcon,0,IDI_APPLICATION
	mov	[wc.hIcon],eax
	mov	[wc.style],0
	mov	[wc.lpfnWndProc],WindowProc
	mov	[wc.cbClsExtra],0
	mov	[wc.cbWndExtra],0
	mov	eax,[hinstance]
	mov	[wc.hInstance],eax
	mov	[wc.hbrBackground],0
	mov	dword [wc.lpszMenuName],0
	mov	dword [wc.lpszClassName],_class
	invoke	RegisterClass,wc
	mov [dwExStyle],WS_EX_APPWINDOW
	mov [dwStyle],WS_VISIBLE+WS_CAPTION+WS_SYSMENU
	invoke ShowCursor,0
	xor eax,eax
	mov [rec.left],eax
	mov [rec.top],eax
	mov [rec.right],XRES
	mov [rec.bottom],YRES
	invoke AdjustWindowRect,rec,[dwStyle],0
	mov eax,[rec.left]
	sub [rec.right],eax
	mov eax,[rec.top]
	sub [rec.bottom],eax
	xor eax,eax
	mov [rec.left],eax
	mov [rec.top],eax
	invoke	CreateWindowEx,[dwExStyle],_class,_title,[dwStyle],0,0,[rec.right],[rec.bottom],0,0,[hinstance],0
	mov	[hwnd],eax
	invoke GetDC,[hwnd]
	mov [hDC],eax
	mov [bmi.biSize],sizeof.BITMAPINFOHEADER
	mov [bmi.biWidth],XRES
	mov [bmi.biHeight],-YRES
	mov [bmi.biPlanes],1
	mov [bmi.biBitCount],32
	mov [bmi.biCompression],BI_RGB
	invoke ShowWindow,[hwnd],SW_NORMAL
	invoke UpdateWindow,[hwnd]

;---------- INICIO
restart:
	call estadoInicial
;        call estIni2
	call game
	jmp SYSEND

estIni2:
	call	SYSCLS
	mov	eax, 0
	mov	ebx, 1
	imul	eax,XRES
	add	eax,ebx
	mov	[SYSFRAME+eax*4],$ffffff

	mov	eax, 1
	mov	ebx, 1
	imul	eax,XRES
	add	eax,ebx
	mov	[SYSFRAME+eax*4],$ffffff

	mov	eax, 1
	mov	ebx, 0
	imul	eax,XRES
	add	eax,ebx
	mov	[SYSFRAME+eax*4],$ffffff

	ret

estadoInicial:
	call SYSCLS

	mov eax, $100
	mov ebx, $100
	imul eax,XRES
	add eax,ebx
	mov [SYSFRAME+eax*4],$ffffff

	mov eax, $FF
	mov ebx, $FF
	imul eax,XRES
	add eax,ebx
	mov [SYSFRAME+eax*4],$ffffff

	mov eax, $100
	mov ebx, $FF
	imul eax,XRES
	add eax,ebx
	mov [SYSFRAME+eax*4],$ffffff

	mov eax, $101
	mov ebx, $FF
	imul eax,XRES
	add eax,ebx
	mov [SYSFRAME+eax*4],$ffffff

	mov eax, $FF
	mov ebx, $FE
	imul eax,XRES
	add eax,ebx
	mov [SYSFRAME+eax*4],$ffffff

	ret

game:

	xor	ebx, ebx

llenaSysframeAux:
	mov	eax, [SYSFRAME+ebx*4]
	mov	[SYSFRAMEAUX+ebx*4], eax
	inc	ebx
	cmp	ebx,XRES*YRES
	jl	llenaSysframeAux

	xor	eax, eax
	xor	ecx, ecx

;evaluaPixel:
			  ;En ecx queda el EJE X


cuentaVecinos:
;       implementar vecinos
	xor	edx,edx
	call	vecinosSuperiores
	call	vecinosAdyacentes
	call	vecinosInferiores

	push	eax ecx
	imul	eax,XRES
	add	eax,ecx
	call	viveOMuere
	pop	ecx eax

	inc	ecx
	cmp	ecx, XRES
	jle	cuentaVecinos

	xor	ecx, ecx
	inc	eax
	cmp	eax, YRES
	jle	cuentaVecinos

	call	SYSREDRAW
	call	SYSUPDATE
	cmp	[SYSKEY],1
	jne	game
	ret

viveOMuere:
	cmp	edx, 2
	jl	muere
	je	sigueViva
	cmp	edx, 3
	je	nace
	jg	muere
	ret

sigueViva:
	cmp	[SYSFRAMEAUX+eax*4],$ffffff
	je	nace
	ret

nace:
	mov	[SYSFRAME+eax*4],$ffffff
	ret

muere:
	mov	[SYSFRAME+eax*4],$000000
	ret

vecinosSuperiores:
	push	eax ecx
	dec	eax
	js	_end

vecSupIzq:
	dec	ecx
	js	vecSup
	call	determinaSiEstaVivo

vecSup:
	inc	ecx
	call	determinaSiEstaVivo

vecSupDer:
	inc	ecx
	cmp	ecx, XRES
	jg	_end
	call	determinaSiEstaVivo
	jmp	_end

vecinosAdyacentes:
	push	eax ecx

vecIzq:
	dec	ecx
	js	vecDer
	call	determinaSiEstaVivo

vecDer:
	add	ecx, 2
	cmp	ecx, XRES
	jg	_end
	call	determinaSiEstaVivo
	jmp	_end

vecinosInferiores:
	push	eax ecx
	inc	eax
	cmp	eax, YRES
	jg	_end

vecInfIzq:
	dec	ecx
	js	vecInf
	call	determinaSiEstaVivo

vecInf:
	inc	ecx
	call	determinaSiEstaVivo

vecInfDer:
	inc	ecx
	cmp	ecx, XRES
	jg	_end
	call	determinaSiEstaVivo
	jmp	_end

_end:
	pop	ecx eax
	ret

determinaSiEstaVivo:
	push	eax ecx
	imul	eax,XRES
	add	eax,ecx
;        mov     ecx, [SYSFRAMEAUX+eax*4]
	cmp	[SYSFRAMEAUX+eax*4],$ffffff
	jne	_end2
	inc	edx
	jmp	_end2
_end2:
	pop	ecx eax
	ret



;---ejemplo 2 uso de mouse
test2:
	call SYSCLS
loop2:
	mov eax, [SYSXYM]
	mov ebx,eax
	shr eax,16
	and ebx,$ffff


	imul eax,XRES
	add eax,ebx
	mov [SYSFRAME+eax*4],$ffffff

	call SYSREDRAW
	call SYSUPDATE
	cmp [SYSKEY],1
	jne loop2
	ret

; OS inteface
;===============================================
align 16
SYSUPDATE: ; ( -- )
	push eax ebx edx ecx
	mov [SYSKEY],0
	invoke	PeekMessage,msg,0,0,0,PM_NOREMOVE
	or	eax,eax
	jz	.noEvent
	invoke	GetMessage,msg,0,0,0
	or	eax,eax
	jz	.endApp
	invoke	TranslateMessage,msg
	invoke	DispatchMessage,msg
.noEvent:
	pop ecx edx ebx eax
	ret
.endApp:
	pop ecx edx ebx eax
;===============================================
align 16
SYSEND: ; ( -- )
	invoke ReleaseDC,[hwnd],[hDC]
	invoke DestroyWindow,[hwnd]
	invoke ExitProcess,0
	ret
;===============================================
align 16
SYSREDRAW: ; ( -- )
	pusha
	invoke SetDIBitsToDevice,[hDC],0,0,XRES,YRES,0,0,0,YRES,SYSFRAME,bmi,0
	popa
	ret
;===============================================
align 16
SYSCLS: 	; ( -- )
	pusha
	mov eax,[SYSPAPER]
	lea edi,[SYSFRAME]
	mov ecx,XRES*YRES
	rep stosd
	popa
	ret

;===============================================
align 16
SYSCLSAUX:	   ; ( -- )
	pusha
	mov eax,[SYSPAPER]
	lea edi,[SYSFRAMEAUX]
	mov ecx,XRES*YRES
	rep stosd
	popa
	ret
;===============================================
SYSMSEC: ;  ( -- eax=msec
	lea esi,[esi-4]
	mov [esi], eax
	invoke GetTickCount
	ret
;===============================================
SYSTIME: ;  ( -- ecx=s ebx=m eax=h )
	invoke GetLocalTime,SysTime
	movzx eax,word [SysTime.wHour]
	movzx ebx,word [SysTime.wMinute]
	movzx ecx,word [SysTime.wSecond]
	ret
;===============================================
SYSDATE: ;  ( -- eax=y ebx=m ecx=d )
	invoke GetLocalTime,SysTime
	movzx eax,word [SysTime.wYear]
	movzx ebx,word [SysTime.wMonth]
	movzx ecx,word [SysTime.wDay]
	ret
;===============================================
SYSLOAD: ; edi='from eax="filename"
	invoke CreateFile,eax,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_FLAG_SEQUENTIAL_SCAN,0
	mov [hdir],eax
	or eax,eax
	jz .end
.again:
	invoke ReadFile,[hdir],edi,$fffff,cntr,0
	mov eax,[cntr]
	add edi,eax
	or eax,eax
	jnz .again
	invoke CloseHandle,[hdir]
	mov eax,edi
.end:
	ret

;===============================================
SYSSAVE: ; edx='from ecx=cnt eax="filename" --
	push edx ecx
	invoke CreateFile,eax,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_FLAG_SEQUENTIAL_SCAN,0
	mov [hdir],eax
	pop ecx edx
	or eax,eax
	jz .saveend
	invoke WriteFile,[hdir],edx,ecx,cntr,0
	cmp [cntr],ecx
	je .saveend
	or eax,eax
	jz .saveend
	invoke CloseHandle,[hdir]
.saveend:
	ret

;--------------------------------------
proc WindowProc hwnd,wmsg,wparam,lparam
	mov	eax,[wmsg]
;        cmp     eax,WM_MOUSEMOVE
;        je      wmmousemove
	cmp	eax,WM_LBUTTONUP
	je	wmmouseev
	cmp	eax,WM_MBUTTONUP
	je	wmmouseev
	cmp	eax,WM_RBUTTONUP
	je	wmmouseev
	cmp	eax,WM_LBUTTONDOWN
	je	wmmouseev
	cmp	eax,WM_MBUTTONDOWN
	je	wmmouseev
	cmp	eax,WM_RBUTTONDOWN
	je	wmmouseev
       cmp     eax,WM_KEYUP
       je      wmkeyup
       cmp     eax,WM_KEYDOWN
	je	wmkeydown
  defwindowproc:
	invoke	DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
	ret
  wmmousemove:
	mov eax,[lparam]
	mov [SYSXYM],eax
	xor eax,eax
	ret
  wmmouseev:
	mov eax,[lparam]
	mov [SYSXYM],eax
	xor eax,eax
	ret
  wmkeyup:
	mov eax,[lparam]
	shr eax,16
	and eax,$7f
	or eax,$80
	mov [SYSKEY],eax
	xor eax,eax
	ret
  wmkeydown:			; cmp [wparam],VK_ESCAPE ; je wmdestroy
	mov eax,[lparam]
	shr eax,16
	and eax,$7f
	mov [SYSKEY],eax
	xor eax,eax
	ret
endp
;----------------------------------------------
section '.idata' import data readable

library kernel,'KERNEL32.DLL', user,'USER32.DLL', gdi,'GDI32.DLL'
import kernel,\
	 GetModuleHandle,'GetModuleHandleA', CreateFile,'CreateFileA',\
	 ReadFile,'ReadFile',  WriteFile,'WriteFile',\
	 CloseHandle,'CloseHandle', GetTickCount,'GetTickCount',\
	 ExitProcess,'ExitProcess', GetLocalTime,'GetLocalTime',\
	 SetCurrentDirectory,'SetCurrentDirectoryA', FindFirstFile,'FindFirstFileA',\
	 FindNextFile,'FindNextFileA',	FindClose,'FindClose'

import user,\
	 RegisterClass,'RegisterClassA', CreateWindowEx,'CreateWindowExA',\
	 DestroyWindow,'DestroyWindow', DefWindowProc,'DefWindowProcA',\
	 GetMessage,'GetMessageA', PeekMessage,'PeekMessageA',\
	 TranslateMessage,'TranslateMessage', DispatchMessage,'DispatchMessageA',\
	 LoadCursor,'LoadCursorA', LoadIcon,'LoadIconA',\
	 SetCursor,'SetCursor', MessageBox,'MessageBoxA',\
	 PostQuitMessage,'PostQuitMessage', WaitMessage,'WaitMessage'	 ,\
	 ShowWindow,'ShowWindow', UpdateWindow,'UpdateWindow',\
	 ChangeDisplaySettings,'ChangeDisplaySettingsA', GetDC,'GetDC',\
	 ReleaseDC,'ReleaseDC', AdjustWindowRect,'AdjustWindowRect',\
	 ShowCursor,'ShowCursor'

import gdi,\
	SetDIBitsToDevice,'SetDIBitsToDevice'

section '.data' data readable writeable

	hinstance	dd 0
	hwnd		dd 0
	wc		WNDCLASS ;EX?
	msg		MSG
	hDC		dd 0
	dwExStyle	dd 0
	dwStyle 	dd 0
	rec		RECT
	bmi		BITMAPINFOHEADER
	SysTime 	SYSTEMTIME
	hdir		dd 0
	afile		dd 0
	cntr		dd 0
	_title		db 'asm',0
	_class		db 'asm',0
align 4
	SYSXYM	dd 0
	SYSBM	dd 0
	SYSKEY	dd 0
	SYSPAPER dd 0

align 16 ; CUADRO DE VIDEO (FrameBuffer)

	SYSFRAMEAUX	rd XRES*YRES
	SYSFRAME	rd XRES*YRES
	SYSFRAM2E	rd XRES*YRES
	SYSFRAM22E	rd XRES*YRES