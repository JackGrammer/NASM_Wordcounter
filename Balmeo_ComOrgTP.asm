section .data
	prompt db "Enter sentence: ", 0
	output db "Word Count: ", 0
	newline db 10, 0
	buffer times 256 db 0
	numbuf times 16 db 0

section .text
	global _start

_start:
	; print prompt
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt
	mov edx, 17
	int 0x80

	; read input
	mov eax, 3
	mov ebx, 0
	mov ecx, buffer
	mov edx, 256
	int 0x80

	; count words
	mov esi, buffer
	xor ecx, ecx
	xor edx, edx

count_loop:
	mov al, [esi]
	cmp al, 0
	je end_count
	cmp al, 10
	je end_count

	; checks if whitespace
	cmp al, ' '
	je whitespace
	cmp al, 9
	je whitespace
	cmp al, 13
	je whitespace

	; not whitespace
	cmp edx, 0
	jne next_char
	inc ecx
	mov edx, 1
	jmp next_char

whitespace:
	mov edx, 0

next_char:
	inc esi
	jmp count_loop

end_count:
	mov eax, ecx
	lea edi, [numbuf+15]
	mov byte [edi], 0
	dec edi
	mov byte [edi], 10

	cmp eax, 0
	jne convert_loop
	mov byte [edi], '0'
	jmp print_result

convert_loop:
	xor edx, edx
	mov ebx, 10
	div ebx
	add dl, '0'
	dec edi
	mov [edi], dl
	cmp eax, 0
	jne convert_loop

print_result:
	mov eax, 4
	mov ebx, 1
	mov ecx, output
	mov edx, 16
	int 0x80

	mov ecx, edi
	lea edx, [numbuf+16]
	sub edx, edi
	mov eax, 4
	mov ebx, 1
	int 0x80

	mov eax, 1
	xor ebx, ebx
	int 0x80
