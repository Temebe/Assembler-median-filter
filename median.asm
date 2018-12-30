section	.text
global median

median:
	push ebp
	push ebx
	mov ebp, esp
	mov eax, [ebp+12] ;moving *s to eax
	mov ecx, 0 ; amount of chars in string
	mov bl, 0 ; counter for loop
	add cl, 9
	add ch, 8

pre_loop:
	cmp bl, cl
	je end
	mov eax, [ebp+12]
	inc bl
	mov bh, 0

sort_loop:
	mov dl, [eax]
	mov dh, [eax+1]
	cmp bh, ch
	je pre_loop
	inc eax
	inc bh
	cmp dl, dh
	jle sort_loop 
	mov [eax], dl
	mov [eax-1], dh
	jmp sort_loop
	
end:
;	mov eax, [ebp+8]
;	mov ebx, [ebp+12]
	mov eax, 0
	mov eax, [ebp+12]
	add eax, 4
	mov eax, [eax]
	mov esp, ebp
	pop ebx
	pop ebp
	ret
