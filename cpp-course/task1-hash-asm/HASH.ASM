	org 100h

	call precalc	;���������� �����

	call input	;���� ���

	call output	;����� ����������

	mov ax, 4C00h	;exit
	int 21h

precalc: ;���������� �����
  mov al, 1
  mov bl, 29
  mov di, hash	      ;����� ������ ������� �����
  mov cx, 63
  mov [di], al

  lp_pr:
    inc di
    mul bl
    mov [di], al
    loop lp_pr

  ret

;���� ��� key-value
input:
  part1:
    mov si, cur_str	  ;��������� ����
    xor bx, bx		  ;����� ������
    mov ah, 1		  ;��� ������� ����������

  read_key:
    int 21h
    cmp al, 0Dh 	   ;���� ����� ������,
    je end_of_reading	  ;�� ��������� � ������
    cmp al, 32		  ;���� ������,
    je get_hash 		;�� ������� ���
    mov [si], al
    inc si
    inc bx
    jmp read_key

  part2:
    mov si, cur_str	;������ ����� ����� ��������
    xor bx, bx
    mov ah, 1

  read_value:
    int 21h
    cmp al, 0Dh 	  ;���� ����� ������,
    je add_to_map	  ;�� ��������� ��������
    mov [si], al
    inc si
    inc bx
    jmp read_value

  end_of_reading:
    mov ax, 1		;��� � print
    mov [met], ax
    ret

;�������� ��� ������
get_hash:
  mov cx, bx		;����� ������ � cx
  mov si, cur_str
  mov bx, hash		;� bx ����� ����
			;� � ����� �������� ���
  xor di, di
  ;xor ax, ax
  ;bl += (str[i] - 'a' + 1) * hash[i]
  calc:
    mov al, [si]
    sub al, 'a'
    inc al

    push bx
    mov bx, [bx]
    mul bl
    pop bx

    inc si
    inc bx

    add di, ax
    and di, 0x00FF	;di %= 256
    loop calc

  push di		;��� � di

  mov ax, [met]       ;���� ������ �� print'a
  cmp ax, 1
  je back_to_print

  jmp part2

;�������� �������� � hashmap �� �����
add_to_map:
  mov cx, bx
  mov si, cur_str
  mov bx, map
  mov al, [max_str_size]
  pop dx
  mul dl		;� ax ������ ����� ������ � ����
  add bx, ax

  mov di, mas_str_size	;m_s_s[dx] = cl
  add di, dx		;����� ������ � ����� dx
  mov [di], cl

  write:
    mov al, [si]
    mov [bx], al
    inc bx
    inc si
    loop write

  jmp part1

;����� �������� �� �����
output:
  mov ah, 1
  mov si, cur_str
  xor bx, bx
  int 21h
  cmp al, 0Dh		 ;���� ����� ������, �� ���������
  je the_end
  mov [si], al
  inc si
  inc bx

  read_key_1:
    int 21h
    cmp al, 0Dh
    je print
    mov [si], al
    inc si
    inc bx
    jmp read_key_1

  the_end:
    ret

;������� �������� �� map'a �� �����
print:
  jmp get_hash
back_to_print:
  pop dx		;��� � dx(������ dl)
  mov bx, map
  mov al, [max_str_size]
  mul dl
  add bx, ax

  mov di, mas_str_size
  add di, dx
  xor cx, cx
  mov cl, [di]
  cmp cx, 0
  jz print_err

  mov ah, 02h
  print_char:
    mov dl, [bx]
    int 21h
    inc bx
    loop print_char

  mov ah, 09h
  mov dx, crlf
  int 21h

  jmp output

print_err:
  mov ah, 09h
  mov dx, err_msg
  int 21h
  jmp output

;#
hash: rb 64	     ;����
cur_str: rb 64	     ;������� ������
mas_str_size: rb 256 ;������ ���� ����� � map'�
map: rb 16384	     ;������ ������, 64 * 256
met: dw 0	     ;������ � ���, ��� ������ ������ ������ �����
max_str_size: db 64  ;����� �� ���� ������
err_msg: db 'No value with such key', 13, 10, '$'
crlf: db 13, 10, '$'



