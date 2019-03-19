;-----------------------------------------------
; 11. Leer un número desde el teclado, y escribir 
; 0 si tiene cantidad par de unos y 1 en caso contrario.
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

        ; eax is the number we want to calculate the number of 1s
        mov     eax, [num]
        
        ; ebx is the number of 1s
        xor     ebx, ebx

        .for: 
        
        test    eax, 1
        je      .endif
        
        inc     ebx
        .endif:
        shr     eax, 1
        cmp     eax, 0
        je      .endfor
        jmp     .for
        .endfor:

        and     ebx, 1

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
        i               db ?

section '.idata' data import readable

        include "macro\import32.inc"

        library msvcrt, "MSVCRT.DLL"

        import msvcrt,\
                printf ,'printf',\
                scanf  ,'scanf',\
                exit   ,'exit'

