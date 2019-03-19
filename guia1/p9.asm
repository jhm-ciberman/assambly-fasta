;-----------------------------------------------
; 9. Leer un número desde el teclado, y escribir 
; 0 si el número es par o 1 si es impar.
;-----------------------------------------------

format PE
entry main

section '.text' code readable executable

main:
	push	_ask
	call	[printf]
	add 	esp, 4

	push	num
	push	_format_input
	call	[scanf]
	add 	esp, 8

	mov 	eax, [num]
	and		eax, 1
	mov		[num], eax

	push	eax
	push	_format_output
	call	[printf]
	add 	esp, 8

	push	0
	call	[exit]
	ret

section '.data' data readable writeable

	_ask            db "Ingrese un numero:",0
	_format_input   db "%d",0
	_format_output  db "Resultado= %d",10,0

	num		dd ?

section '.idata' data import readable

	include "macro\import32.inc"

	library msvcrt, "MSVCRT.DLL"

	import msvcrt,\
		printf ,'printf',\
		scanf  ,'scanf',\
		exit   ,'exit'

