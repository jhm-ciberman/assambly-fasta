;-----------------------------------------------
; 15. Leer una lista de ceros o unos por teclado, 
; que representan un valor binario ingresado desde 
; el LSB al MSB y escribir su equivalente en decimal. 
; El fin de lista se indica con un número distinto de cero o uno.
; Ej:si se ingresa la siguiente lista
; ? 0
; ? 0
; ? 0
; ? 1
; ? 2
; 	El resultado debe ser:
; 8
;-----------------------------------------------

format PE
entry main

section '.text' code readable executable

main:
        ; show question to user
        push    _ask
        call    [printf]
        add     esp, 4

        ; read input
        push    angle
        push    _format_input
        call    [scanf]
        add     esp, 8


        push    dword [angle]
        push    _format_output
        call    [printf]
        add     esp, 8


        ; exit
        push    0
        call    [exit]
        ret

section '.data' data readable writeable

        _ask            db "Ingrese un numero:",0
        _format_input   db "%f",0
        _format_output  db "Resultado= %4.2f",10,0

        angle           dd ?

section '.idata' data import readable

        include "macro\import32.inc"

        library msvcrt, "MSVCRT.DLL"

        import msvcrt,\
                printf ,'printf',\
                scanf  ,'scanf',\
                exit   ,'exit'

