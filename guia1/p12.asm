;-----------------------------------------------
; 12. Leer dos números desde teclado, el primero representa un valor
; decimal y el segundo un bit en particular de ese valor. 
; Escribir por pantalla el valor del bit indicado, se debe validar 
; que el segundo valor se encuentre dentro del rango de 0 a 15, 
; en caso contrario se debe escribir cero.
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
        push    num
        push    _format_input
        call    [scanf]
        add     esp, 8

        ; [num] is the number we want to fetch the bit from

        ; show another question to user
        push    _ask
        call    [printf]
        add     esp, 4

        ; read input
        push    index
        push    _format_input
        call    [scanf]
        add     esp, 8

        ; [index] is the number of the bit we want to use
        mov     eax, [index]

        ; validate the input
        cmp     eax, 0
        jl      .non_valid
        cmp     eax, 15
        jg      .non_valid
        jmp     .valid

        .non_valid:
        ; ecx is the result
        mov     ebx, 0
        jmp     .result

        .valid:
        ; the number is valid

        ; retrieve [num] from memory
        mov     ebx, [num]

        .for:
        cmp     eax, 0
        je      .endfor
        shr     ebx, 1
        dec     eax
        jmp     .for
        .endfor:

        and     ebx, 1

        .result:
        ; print result
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
        index           dd ?

section '.idata' data import readable

        include "macro\import32.inc"

        library msvcrt, "MSVCRT.DLL"

        import msvcrt,\
                printf ,'printf',\
                scanf  ,'scanf',\
                exit   ,'exit'

