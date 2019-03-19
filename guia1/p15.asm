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
        xor     eax, eax
        mov     [num], eax

        .theloop: 

        ; show question to user
        push    _ask
        call    [printf]
        add     esp, 4

        ; read input
        push    bit
        push    _format_input
        call    [scanf]
        add     esp, 8

        mov     eax, [bit]       ; eax is our bit
        mov     ebx, [num]       ; ebx is our number


        cmp     eax, 1
        je     .addone
        cmp     eax, 0
        je     .addzero
        jmp     .printnumber

        .addone:
        shl     ebx, 1
        inc     ebx
        mov     [num], ebx
        jmp     .theloop

        .addzero:
        shl     ebx, 1
        mov     [num], ebx
        jmp     .theloop

        .printnumber:
        push    ebx
        push    _format_output
        call    [printf]
        add     esp, 8


        ; exit
        push    0
        call    [exit]
        ret

section '.data' data readable writeable

        _ask            db "Ingrese un numero:",0
        _format_input   db "%d",0
        _format_output  db "Resultado= %d",10,0

        num             dd ?
        bit             dd ?

section '.idata' data import readable

        include "macro\import32.inc"

        library msvcrt, "MSVCRT.DLL"

        import msvcrt,\
                printf ,'printf',\
                scanf  ,'scanf',\
                exit   ,'exit'

