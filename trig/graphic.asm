; ----------------------
; Constants
; ----------------------

SCREEN_W equ 400
SCREEN_H equ 300

; ----------------------
; Global variables
; ----------------------
section '.data' data readable writeable
align 16 ; CUADRO DE VIDEO (FrameBuffer)
    SCREEN_BUFFER rd SCREEN_W*SCREEN_H

    DEST_BUFFER dd ?
    DEST_W      dd ?
    DEST_H      dd ?
; ----------------------
; Functions
; ----------------------

 
; void draw_pixel(x, y, col)
; Arguments: 
;   x       [ebp+8]  The x position 
;   y       [ebp+12] The y position
;   col     [ebp+16] The color to fill the pixel
_draw_pixel:
    push    ebp
    mov     ebp, esp

    ; if (x >= dest_w) return;
    mov     eax, [DEST_W]
    cmp     [ebp+8], eax
    jge     .return

    ; if (y >= dest_y) return;
    mov     ebx, [DEST_H]
    cmp     [ebp+12], ebx
    jge     .return
    
    ; alphatest
    ; if (col.alpha == 0) return;
    mov     ebx, [ebp+16]
    and     ebx, $FF000000 ; get only the alpha value
    jz      .return 

    mov     ebx, [ebp+16]
    mul     dword[ebp+12]
    add     eax, [ebp+8]

    
    mov     ecx, [DEST_BUFFER]

    mov     esi, 4
    mov     [ecx+eax*4],ebx    ; puts col in SOURCE_BUFFER[eax] 

    .return:
    mov     esp, ebp
    pop     ebp
    ret

; void draw_horizontal_line(x, y, width, col)
; Arguments: 
;   x       [ebp+8]  The starting x position 
;   y       [ebp+12] The starting y position
;   width   [ebp+16] The width of the line
;   col     [ebp+20] The color to fill the line
_draw_horizontal_line:
    push    ebp
    mov     ebp, esp

    cmp     dword[ebp+16], 0    ; while (width != 0) then
    .while:
    jz      .endwhile
    
    ; draw_pixeL(x, y, col)
    ccall   _draw_pixel, [ebp+8], [ebp+12], [ebp+20]

    inc     dword[ebp+8]        ; x += 1; 
    dec     dword[ebp+16]       ; width -= 1;
    jmp     .while
    .endwhile:

    mov     esp, ebp
    pop     ebp
    ret

; void draw_quad(x1, y1, width, height, col)
; Arguments: 
;   x       [ebp+8]  The starting x position 
;   y       [ebp+12] The starting y position
;   width   [ebp+16] The width of the line
;   height  [ebp+20] The height of the line
;   col     [ebp+24] The color to fill the line
_draw_quad:
    push    ebp
    mov     ebp, esp

    cmp     dword[ebp+20], 0    ; while (height != 0)
    .while:
    jz      .endwhile
    
    ; draw_horizontal_line(x, y, width, col)
    ccall   _draw_horizontal_line, [ebp+8], [ebp+12], [ebp+16], [ebp+24]

    inc     dword[ebp+12]       ; y += 1; 
    dec     dword[ebp+20]       ; height -= 1;
    jmp     .while
    .endwhile:

    mov     esp, ebp
    pop     ebp
    ret



; int get_pixel(sprite, x, y, width)
; Arguments: 
;   sprite  [ebp+8]  The memory address of the first pixel data of the sprite
;   x       [ebp+12] The starting x position 
;   y       [ebp+16] The starting y position
;   width   [ebp+20] The width of the line
; Returns:
;   The color of the pixel(x,y) of the sprite.
_get_pixel:
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp+16]
    mul     dword[ebp+20]
    add     eax, [ebp+12]
    shl     eax, 2

    add     eax, dword[ebp+8]
    mov     eax, [eax]


    mov     esp, ebp
    pop     ebp
    ret


; void draw_sprite(sprite, x, y, width, height)
; Arguments: 
;   sprite  [ebp+8]  The memory address of the first pixel data of the sprite
;   x       [ebp+12] The starting x position 
;   y       [ebp+16] The starting y position
;   width   [ebp+20] The width of the line
;   height  [ebp+24] The height of the line
; Vars: 
;   i       [ebp-4]
;   j       [ebp-8]
; Pseudocode: 
; for (i = 0; i < width; i++) {
;   for (j = 0; j < height; j++) {
;     draw_pixel(x + i, y + j, sprite[j * height + i]);
;   }  
; }
_draw_sprite:
    push    ebp
    mov     ebp, esp
    sub     esp, 8

    ; for (i = 0; i < width; i++) {
    mov     dword[ebp-4], 0
    .for_i:
    mov     eax, [ebp-4]
    cmp     eax, dword[ebp+20] 
    jnl      .endfor_i
    
    ;   for (j = 0; j < height; j++) {
    mov     dword[ebp-8], 0
    .for_j:
    mov     eax, [ebp-8]
    cmp     eax, dword[ebp+24] 
    jnl      .endfor_j

    ; eax = sprite[j * width + i]
    mov     eax, [ebp-8]
    mul     dword[ebp+20]
    add     eax, [ebp-4]
    shl     eax, 2
    add     eax, dword[ebp+8]
    mov     eax, [eax]

    ; ebx = i + x;
    mov     ebx, [ebp-4]
    add     ebx, [ebp+12]

    ; ecx = j + y;
    mov     ecx, [ebp-8]
    add     ecx, [ebp+16]

    ; draw_pixel(i + x, j + y, eax);
    ccall   _draw_pixel, ebx, ecx, eax

    ; j++;
    inc     dword[ebp-8] 
    jmp     .for_j
    .endfor_j:

    ; i++;
    inc     dword[ebp-4] 
    jmp     .for_i
    .endfor_i:

    mov     esp, ebp
    pop     ebp
    ret

; void copy_buffer(sprite, width, height, pixelsize)
; Arguments: 
;   sprite      [ebp+8]  The memory address of the first pixel data of the sprite
;   width       [ebp+12] The width of the line
;   height      [ebp+16] The height of the line
;   pixelsize   [ebp+20] The size of each pixel
; Vars: 
;   i       [ebp-4]
;   j       [ebp-8]
_copy_buffer:
    push    ebp
    mov     ebp, esp
    sub     esp, 8

    ; for (i = 0; i < width; i++) {
    mov     dword[ebp-4], 0
    .for_i:
    mov     eax, [ebp-4]
    cmp     eax, dword[ebp+12] 
    jnl      .endfor_i
    
    ;   for (j = 0; j < height; j++) {
    mov     dword[ebp-8], 0
    .for_j:
    mov     eax, [ebp-8]
    cmp     eax, dword[ebp+16] 
    jnl      .endfor_j

    mov     eax, dword[ebp-4]
    mul     dword[ebp+20]
    mov     ebx, eax

    mov     eax, [ebp-8]
    mul     dword[ebp+20]
    mov     ecx, eax

    ; eax = sprite[j * width + i]
    mov     eax, [ebp-8]
    mul     dword[ebp+12]
    add     eax, [ebp-4]
    shl     eax, 2
    add     eax, dword[ebp+8]
    mov     eax, [eax]

    ccall _draw_quad, ebx, ecx, [ebp+20], [ebp+20], eax

    ; j++;
    inc     dword[ebp-8] 
    jmp     .for_j
    .endfor_j:

    ; i++;
    inc     dword[ebp-4] 
    jmp     .for_i
    .endfor_i:

    mov     esp, ebp
    pop     ebp
    ret