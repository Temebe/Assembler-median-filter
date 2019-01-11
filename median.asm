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
	cmp bh, ch
	je pre_sort_loop
	mov dl, [eax]
	mov dh, [eax + 1]
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
	add eax, [ebp+20] ; Multiplying by adding
	add eax, [ebp+20] ; Both for efficient and simplicity
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
	mov ebx, 0
	add ebx, 6 ; We're starting from 6 since we don't want to take corners

down_line:
	mov cx, [ebp+20]
	add cx, [ebp+20]
	add cx, [ebp+20]
	cmp bx, cx ; check if you delivered all the pixels from line
	je pre_right_down_corner
	push ebx ; push counter
	mov ecx, sort_array
	push eax ; push input address
	; add three down pixels
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	inc ecx
	; jump to next line
	add eax, [ebp+20]
	add eax, [ebp+20] 
	add eax, [ebp+20]
	; add three up pixels
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	mov ecx, 0
	add cl, 6
	call sort ; sort 6 pixels
	; couting average for median
	mov eax, 0
	mov al, [sort_array + 2]
	mov ecx, 0
	mov cl, [sort_array + 3]
	add ax, cx
	shr eax, 1
	mov [edx], al
	inc edx
	pop eax ; pop input address
	inc eax
	pop ebx ; pop counter
	inc bx
	jmp down_line

pre_right_down_corner:
	mov ebx, 0
	

right_down_corner:
	cmp bl, 3
	je start_mid
	mov ecx, sort_array
	push eax
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	inc ecx
	add eax, [ebp+20] ; Jumping to next line of pixels
	add eax, [ebp+20] ; Multiplying by adding
	add eax, [ebp+20] ; Both for efficient and simplicity
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
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
	jmp right_down_corner

start_mid:
	call write_pixel
	mov ebx, 0 ;ebx will serve as a counter again
	add ebx, 2
	push ebx

mid_begin:
	pop ebx ; pop iterator from stack
	cmp bx, [ebp+24]
	je pre_left_up_corner
	inc ebx
	push ebx ; pop iterator back to stack
	mov ebx, 0

mid_left:
	cmp bl, 3
	je pre_mid_line
	mov ecx, sort_array
	push eax
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	add eax, [ebp+20]
	add eax, [ebp+20]
	add eax, [ebp+20]
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	mov cl, 6
	call sort
	; counting average of 2 pixels
	mov eax, 0
	mov al, [sort_array + 2]
	mov ecx, 0
	mov cl, [sort_array + 3]
	add ax, cx
	shr eax, 1
	mov [edx], al
	inc edx
	pop eax
	inc eax
	inc bl
	jmp mid_left

pre_mid_line:
	;call write_pixel
	mov ebx, 0
	add ebx, 6

mid_line:
	mov cx, [ebp+20]
	add cx, [ebp+20]
	add cx, [ebp+20]
	cmp bx, cx ; check if you delivered all the pixels from line
	je pre_mid_right
	push ebx ; push counter
	mov ecx, sort_array
	push eax ; push input address
	; add three down pixels
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	inc ecx
	; jump to next line
	add eax, [ebp+20]
	add eax, [ebp+20] 
	add eax, [ebp+20]
	; add three up pixels
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	inc ecx
	; jump to lower line
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	; add three down pixels
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov cl, 9
	call sort ; sort 9 pixels
	; putting middle pixel to output
	mov al, [sort_array + 4]
	mov [edx], al
	inc edx
	pop eax ; pop input address
	inc eax
	pop ebx ; pop counter
	inc bx
	jmp mid_line

pre_mid_right:
	mov ebx, 0

mid_right:
	cmp bl, 3
	je mid_begin
	mov ecx, sort_array
	push eax
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	inc ecx
	add eax, [ebp+20]
	add eax, [ebp+20]
	add eax, [ebp+20]
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	inc ecx
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	sub eax, [ebp+20]
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	mov cl, 6
	call sort
	; counting average of 2 pixels
	mov eax, 0
	mov al, [sort_array + 2]
	mov ecx, 0
	mov cl, [sort_array + 3]
	add ax, cx
	shr eax, 1
	mov [edx], al
	inc edx
	;mov ecx, output_array
	;add cl, bl
	;mov [ecx], eax ; put average pixel to array
	pop eax
	inc eax
	inc bl
	jmp mid_right

pre_left_up_corner:
	mov ebx, 0
	
left_up_corner:
	cmp bl, 3
	je pre_up_line
	mov ecx, sort_array
	push eax
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	sub eax, [ebp+20] ; Jumping to next line of pixels
	sub eax, [ebp+20] ; Multiplying by adding
	sub eax, [ebp+20] ; Both for efficient and simplicity
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
	jmp left_up_corner

pre_up_line:
	call write_pixel
	mov ebx, 0
	add bl, 6 ; We're starting from 6 since we don't want to take corners

up_line:
	mov cx, [ebp+20]
	add cx, [ebp+20]
	add cx, [ebp+20]
	cmp bx, cx ; check if you delivered all the pixels from line
	je pre_right_up_corner
	push ebx ; push counter
	mov ecx, sort_array
	push eax ; push input address
	; add three down pixels
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	inc ecx
	; jump to next line
	sub eax, [ebp+20]
	sub eax, [ebp+20] 
	sub eax, [ebp+20]
	; add three up pixels
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax + 3]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	mov cl, 6
	call sort ; sort 6 pixels
	mov eax, 0
	mov al, [sort_array + 2]
	mov ecx, 0
	mov cl, [sort_array + 3]
	add ax, cx
	shr eax, 1
	mov [edx], al
	inc edx
	pop eax ; pop input address
	inc eax
	pop ebx ; pop counter
	inc bx
	jmp up_line

pre_right_up_corner:
	mov ebx, 0

right_up_corner:
	cmp bl, 3
	je end
	mov ecx, sort_array
	push eax
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
	mov [ecx], bh
	inc ecx
	sub eax, [ebp+20] ; Jumping to next line of pixels
	sub eax, [ebp+20] ; Multiplying by adding
	sub eax, [ebp+20] ; Both for efficient and simplicity
	mov bh, [eax]
	mov [ecx], bh
	inc ecx
	mov bh, [eax - 3]
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
	jmp right_up_corner

end:
	;call write_pixel
	;pop ebx ;for a moment just to finish code
	pop ebx
	pop ebp
	ret
