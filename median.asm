section .data

array TIMES 9 db 0

section	.text
global median

;ebp+12 -> *input
;ebp+16 -> *output
;ebp+20 -> width
;ebp+24 -> height

median:
	push ebp
	push ebx
	mov ebp, esp
	mov eax, [ebp+12] ;moving *s to eax
	mov ecx, array
	mov bl, 0

load_array:
	cmp bl, 9
	je pre_sort
	mov bh, [eax]
	add [ecx], bh
	inc bl
	inc eax
	inc ecx
	jmp load_array

pre_sort:
	mov bl, 0 ; counter for loop
	mov cl, 9
	mov ch, 8

pre_loop:
	cmp bl, cl
	je end
	mov eax, array
	inc bl
	mov bh, 0

sort_loop:
	mov dl, [eax]
	mov dh, [eax + 1]
	cmp bh, ch
	je pre_loop
	inc eax
	inc bh
	cmp dl, dh
	jle sort_loop 
	mov [eax], dl
	mov [eax - 1], dh
	jmp sort_loop


	
end:
	mov eax, [ebp+16]
	mov bl, [array]
	mov [eax], bl
	inc eax
	mov bl, [array + 1]
	mov [eax], bl
	inc eax
	mov bl, [array + 2]
	mov [eax], bl
	inc eax
	mov bl, [array + 3]
	mov [eax], bl
	inc eax
	mov bl, [array + 4]
	mov [eax], bl
	inc eax
	mov bl, [array + 5]
	mov [eax], bl
	inc eax
	mov bl, [array + 6]
	mov [eax], bl
	inc eax
	mov bl, [array + 7]
	mov [eax], bl
	inc eax
	mov bl, [array + 8]
	mov [eax], bl
	pop ebx
	pop ebp
	ret
