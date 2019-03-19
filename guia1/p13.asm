;-----------------------------------------------
; 13. Leer un número desde el teclado, y escribir los 16 bits de su equivalente 
; en binario. Los bits deben mostrarse desde el MSB al LSB.
; Ej: si se ingresa 8 la salida será
;     00000000000000000000000000001000
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

        
        mov     eax, [num]       ; eax is our number
        mov     ecx, 32          ; ecx is our counter

        .for:
        push    ecx             ; save ecx
        push    eax             ; save eax

        mov     ebx, eax        ; ebx is our auxiliary variable to hold '0' or '1'
        shr     ebx, 31
        and     ebx, 1


        push    ebx             ; printf("%d", ebx);
        push    _format_input
        call    [printf]
        add     esp, 8

        pop     eax             ; restore eax
        pop     ecx             ; restore ecx
        
        shl     eax, 1

        dec     ecx             ; same as loop .for
        jnz     .for
        .endfor:


        ; exit
        push    0
        call    [exit]
        ret

section '.data' data readable writeable

        _ask            db "Ingrese un numero:",0
        _format_input   db "%d",0
        _format_output  db "Resultado= %d",10,0

        num             dd ?
        i               dd ?

section '.idata' data import readable

        include "macro\import32.inc"

        library msvcrt, "MSVCRT.DLL"

        import msvcrt,\
                printf ,'printf',\
                scanf  ,'scanf',\
                exit   ,'exit'

