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
        push    angled
        push    _format_input
        call    [scanf]
        add     esp, 8


        ; push    eax
        ; call    _sin
        ; add     esp, 4

        

        fld    dword [angled]
        ; fcos
        fstp   qword [angleq]

        ; mov     eax, [angle]

        push    dword [angleq+4]
        push    dword [angleq]
        push    _format_output
        call    [printf]
        add     esp, 8


        ; exit
        push    0
        call    [exit]
        ret


; Taylor aproximation
; sin(x) = x - (x^3)/6 + (x^5) / 120 - (x^7) / 5040
; Pseudocode:
; x2 = x * x;
; x3 = x * x2;
; x5 = x3 * x2;
; x7 = x5 * x2;
; x3 /= 6;
; x5 /= 120;
; x7 /= 5040;
; x -= x3;
; x += x5;
; x -= x7;
@x      equ     [ebp+8]
; vars
@x3      equ [ebp-4]
@x5       equ [ebp-8]
@x7       equ [ebp-12]
_sin: 
    push    ebp
    mov     ebp, esp
    sub     esp, 12

    and     

    leave
    ret


section '.data' data readable writeable

        _ask            db "Ingrese un numero:",0
        _format_input   db "%d",0
        _format_output  db "Resultado= %f",10,0

        angled           dd ?
        angleq           dq ?
        deg2rad         dd 1143
        rad2deg         dd 3754936

section '.idata' data import readable

        include "macro\import32.inc"

        library msvcrt, "MSVCRT.DLL"

        import msvcrt,\
                printf ,'printf',\
                scanf  ,'scanf',\
                exit   ,'exit'

