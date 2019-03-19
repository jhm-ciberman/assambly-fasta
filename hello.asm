format PE
entry _main
include "win32a.inc"

section '.idata' data import readable

library msvcrt, "MSVCRT.DLL"

import msvcrt, \
	printf , 'printf',\
	scanf  , 'scanf',\
	exit   , 'exit'

section '.data' data readable writeable

_hello          db "numerodsds 1: ",0
_prompt2        db "numero 2: ",0
_format_input   db "%d",0
_format_output  db "Resultado= %d",10,0

section '.text' code readable executable

_main:
	; int num1; -4
	; int num2; -8
	push ebp
	mov ebp, esp
	sub esp, 8

	ccall [printf], _hello
	
	lea   eax, [ebp-4]
	ccall [scanf], _format_input, eax
	ccall [printf], _prompt2

	lea   eax, [ebp-8]
	ccall [scanf], _format_input, eax

	mov   eax, [ebp-4]
	add   eax, [ebp-8]
	shr   eax, 1              ; (num1 - num2) / 2
	ccall [printf], _format_output, eax

	leave                     ; cleanup stack frame. Same as: mov esp, ebp; pop ebp; 

	; return 0;
	push  0
	call  [exit]





