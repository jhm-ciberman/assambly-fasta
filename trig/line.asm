
; void line(int x0, int y0, int x1, int y1) {
;  
;   int dx = abs(x1 - x0)
;   int dy = abs(y1 - y0)
;	int sx = (x0 < x1) ? 1 : -1;
;	int sy = (y0 < y1) ? 1 : -1;
;   int err = (dx > dy ? dx : -dy) / 2;
;   int e2;
;   for(;;){
;     setPixel(x0,y0);
;     if (x0==x1 && y0==y1) break;
;     e2 = err;
;     if (e2 >-dx) { err -= dy; x0 += sx; }
;     if (e2 < dy) { err += dx; y0 += sy; }
;   }
; }

; void draw_line(int x0, int y0, int x1, int y1, col)

; Pseudocode: 
;     int dx = x1 - x0;
;     int dy = y1 - y0;
;     int x = x0;
;     int y = y0;
;     int p = 2 * dy - dx;
;     while(x < x1) {
;         if(p >= 0) {
;             putpixel(x, y, 7);
;             y = y + 1;
;             p = p + 2 * dy - 2 * dx;
;         } else {
;             putpixel(x, y, 7);
;             p = p + 2 * dy;
;         }
;         x = x + 1;
;     }
; Arguments: 
@x0      equ [ebp+8]  ; The starting x position
@y0      equ [ebp+12] ; The starting y position
@x1      equ [ebp+16] ; The ending x position
@y1      equ [ebp+20] ; The ending y position
@col     equ [ebp+24] ; The color of the line
; Vars:
@dx      equ [ebp-4]
@dy      equ [ebp-8]
@x       equ [ebp-12]
@y       equ [ebp-16]
@p       equ [ebp-20]
_draw_line: 
    push    ebp
    mov     ebp, esp
    sub     esp, 20

    ; int dx = x1 - x0; (store in eax)
    mov     eax, @x1
    sub     eax, @x0
    mov     @dx, eax

    ; int dy = y1 - y0; (store in ebx)
    mov     ebx, @y1
    sub     ebx, @y0
    mov     @dy, ebx

    ; int x = x0;
    mov     edx, @x0
    mov     @x, edx

    ; int y = y0;
    mov     edx, @y0
    mov     @y, edx

    ; int p = 2 * dy - dx;
    shl     ebx, 1
    sub     ebx, eax
    mov     @p, ebx

    ; while(x < x1)
    .while: 
    mov     eax, @x
    cmp     eax, @x1
    jge     .endwhile

    ; if(p >= 0)
    mov     ebx, @p
    cmp     ebx, 0
    jl      .else
    
    ccall _draw_pixel, eax, @y, @col

    ;y = y + 1;
    inc     dword @y

    ;p += 2 * (dy - dx);
    mov     eax, @dy
    sub     eax, @dx
    shl     eax, 1
    add     @p, eax

    jmp     .endif
    .else:

    ccall _draw_pixel, eax, @y, $FFFFFFFF

    ; p += 2 * dy;
    mov     eax, @dy
    shl     eax, 1
    add     @p, eax
    .endif:

    ;x = x + 1
    inc     dword @x
    jmp     .while
    .endwhile: 

    mov     esp, ebp
    pop     ebp
    ret
