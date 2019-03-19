
; 
sinp:
	and eax,0x7fff
	sub eax,0x4000
	mov ebx,eax
	cdq
	imul eax
	shrd eax,edx,16
	mov ecx,eax
	mov edi,4876210
	cdq
	imul edi
	;shr eax,16
	shrd eax,edx,16
	sub eax,2699161

	cdq
	imul ecx
	shrd eax,edx,16
	add eax,411769
	cdq
	imul ebx
	shrd eax,edx,16
	ret

; angulo 0.0 -- 0.0
;      360.0 -- 1.0
;  in: eax=angulo out: eax=coseno
cos:
	add eax,0x8000
	test eax,0x8000
	jnz ._1
	jmp sinp
	._1:
	call sinp
	neg eax
	ret

;  in: eax=angulo out: eax=seno
sin:
	add eax,0x4000
	test eax,0x8000
	jnz ._1
	jmp sinp
	._1:
	call sinp
	neg eax
	ret
