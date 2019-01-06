section .data

sort_array TIMES 9 db 0
output_array TIMES 3 db 0

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
	mov ecx, sort_array
	mov edx, [ebp+16] ;output address
	mov bl, 0 ; counter for 
	jmp pre_left_down_corner

;load_array:
;	cmp bl, 9
;	je testf
;	mov bh, [eax]
;	add [ecx], bh
;	inc bl
;	inc eax
;	inc ecx
;	jmp load_array

; SORTING
; Not really optimized sorting as it's just bubble sort with always worst scenario

sort:
	push eax ; needing for storing address
	push ebx ; needed for counting
	push edx ; needed for comparing two bytes
	; ecx is loaded before calling sort
	mov bl, 0 ; counter for loop
	mov ch, cl
	dec ch 

pre_sort_loop:
	cmp bl, cl
	je end_sort
	mov eax, sort_array
	inc bl
	mov bh, 0

sort_loop:
	mov dl, [eax]
	mov dh, [eax + 1]
	cmp bh, ch
	je pre_sort_loop
	inc eax
	inc bh
	cmp dl, dh
	jle sort_loop 
	mov [eax], dl
	mov [eax - 1], dh
	jmp sort_loop

end_sort:
	pop edx
	pop ebx
	pop eax
	ret

; WRITING DOWN PIXEL
; I'm just taking pixel's BGR from output array and writing to file
; Working on edx since it should just keep output address

write_pixel:
	push ebx
	mov bl, [output_array]
	mov [edx], bl
	inc edx
	mov bl, [output_array + 1]
	mov [edx], bl
	inc edx
	mov bl, [output_array + 2]
	mov [edx], bl
	inc edx
	pop ebx
	ret

; END OF CALLABLE FUNCTIONS


pre_left_down_corner:
	mov ebx, 0
	;mov bh, 0

left_down_corner:
	cmp bl, 3
	je pre_down_line
	mov ecx, sort_array
	push eax
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	add eax, [ebp+20] ; Jumping to next line of pixels
	add eax, [ebp+20] ; I'm not sure how to
	add eax, [ebp+20] ; Multiply 3 by [ebp+20] AND add this to eax, maybe lea?
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	mov cl, 4
	call sort
	; counting average of 2 pixels
	mov eax, 0
	add eax, [sort_array + 1]
	add eax, [sort_array + 2]
	mov ah, 0
	shr eax, 1
	mov ecx, output_array
	add cl, bl
	mov [ecx], eax ; put average pixel to array
	pop eax
	inc eax
	inc bl
	jmp left_down_corner

pre_down_line:
	call write_pixel

down_line:

rigth_down_corner:

end:
	pop ebx
	pop ebp
	ret
