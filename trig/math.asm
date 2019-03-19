

; int abs(int x)
; Returns
;   The absolute value
; https://stackoverflow.com/questions/2639173/x86-assembly-abs-implementation
; Params
@x      equ [ebp+8] ; The value to get the absolute value for.
_abs:

    push    ebp
    mov     ebp, esp

    mov     ebx, @x ;store eax in ebx
    mov     eax, ebx
    neg     eax
    cmovl   eax, ebx ;if eax is now negative, restore its saved value

    leave
    ret
