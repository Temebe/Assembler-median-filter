section	.text
global median

median:
	push ebp
	mov ebp, esp

	
end:
	mov byte [ecx], 0
	;mov esp, ebp
	pop ebp
	ret
