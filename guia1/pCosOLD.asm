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


        ; push    eax
        ; call    _sin
        ; add     esp, 4

        

        ;fld    dword [angled]
        ;fcos
        ;fstp   qword [angleq]

        ; mov     eax, [angle]

        ;push    dword [angleq+4]
        push    dword [angle]
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


    mov     eax, @x
    imul    eax         ; eax = x * x
    sar     eax, 16
    mov     ebx, eax    ; ebx = x * x
    
    mul     eax         ; eax = x * x * x
    sar     eax, 16
    mov     @x3, eax    ; x3 = x * x * x
    mov     ecx, @x3    ; ecx = x * x * x

    mul     ebx         ; eax = x3 * x2
    sar     eax, 16
    mov     @x5, eax    ; x5 = x * x * x * x * x

    mul     ecx         ; eax = x5 * x2
    sar     eax, 16
    mov     @x7, eax    ; x7 = x * x * x * x * x * x * x

    xor     edx, edx

    mov     ebx, @x

    mov     eax, @x3
    mov     ecx, 393216 ; 6 << 16
    sal     eax, 16
    div     ecx      
    sub     ebx, eax

    mov     eax, @x5
    mov     ecx, 7864320 ; 120 << 16
    sal     eax, 16
    div     ecx
    add     ebx, eax
    
    mov     eax, @x7
    mov     ecx, 330301440  ; 5040 << 16
    sal     eax, 16
    div     ecx
    sub     ebx, eax

    mov     eax, ebx

    leave
    ret


section '.data' data readable writeable

        _ask            db "Ingrese un numero:",0
        _format_input   db "%f",0
        _format_output  db "Resultado= %f",10,0

        angle           dd ?
;        deg2rad         dd 1143
;        rad2deg         dd 3754936

section '.idata' data import readable

        include "macro\import32.inc"

        library msvcrt, "MSVCRT.DLL"

        import msvcrt,\
                printf ,'printf',\
                scanf  ,'scanf',\
                exit   ,'exit'

