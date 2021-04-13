.model small
.stack 100h
.data
gc db 121
map db 180 dup(0)
fig dw ?
fig1 db 0F0h,00h,10h,20h,41
fig2 db 0F0h,00h,10h,01h,47
fig3 db 0F0h,00h,10h,0FFh,33
fig4 db 0F0h,00h,01h,11h,42
fig5 db 0F1h,00h,01h,10h,43
fig6 db 0F0h,00h,10h,1Fh,53
fig7 db 10h,00h,01h,11h,37
fr db 0Eh,0FFh,0Fh,1Fh,0E0h,0F0h,10h,20h,0F1h,01h,11h,02h
to db 0E0h,0F1h,0F0h,0FFh,02h,01h,0Fh,0Eh,11h,10h,1Fh,20h
m db 10
k dw 10
p db 5
l dw 320
cp dw 24
time dw ?
pause db 0
space1 db     '’ÕÕÕÕÕ∏'
pause_text db '≥PAUSE≥'
space2 db     '¿ƒƒƒƒƒŸ'
P_text db 'P - Pause'
quit_text db 'Q - Quit'
rot_text db ' - Rotate'
left_text db ' - Left'
right_text db ' - Right'
down_text db ' - Down'
score_text db 'Score:'
lines_text db 'Lines:'
level_text db 'Level:'
head_text db 'äè: £‡. 150504, É„‚™Æ¢·™Æ£Æ Ä.Ç.'
go_text db 'GAME OVER'
delay dw 18
d_delay db 3
score dw 0
lines dw 0
level dw 1
.186
.code
print_glass proc
	mov cx,109
puts1:	mov ah,0Ch
	mov al,gc
	inc cx
	mov dx,21
	int 10h
	cmp cx,130
	jne puts1	
	mov dx,20
puts2:	mov ah,0Ch
	mov al,gc
	mov cx,110
	inc dx
	int 10h
	cmp dx,181
	jne puts2
	mov cx,109
puts3:	mov ah,0Ch
	mov al,gc
	inc cx
	mov dx,182
	int 10h
	cmp cx,211
	jne puts3
	mov dx,182
puts4:	mov ah,0Ch
	mov al,gc
	mov cx,211
	dec dx
	int 10h
	cmp dx,21
	jne puts4
	mov cx,212
puts5:	mov ah,0Ch
	mov al,gc
	dec cx
	mov dx,21
	int 10h
	cmp cx,191
	jne puts5
	ret
print_glass endp

print_block proc
	push ax bx si di
	mov cx,111
	mov ax,si
	mul m
	add cx,ax
	mov dx,1
	add dx,bx
	mov ax,dx
	xor dx,dx
	mul l
	add ax,cx
	mov di,ax
	push 0A000h
	pop es
	add si,bx
	mov ax,si
	mov bx,di
	mov cx,10
put1:	movsb
	mov si,ax
	mov di,bx
	add di,320
	mov bx,di
	loop put1
	inc di
	sub di,640
	mov bx,di
	mov si,ax
	mov cx,9
put2:	movsb
	mov si,ax
	mov di,bx
	sub di,320
	mov bx,di
	loop put2
	add di,321
	mov bx,di
	mov cx,8
put3:	movsb
	mov si,ax
	mov di,bx
	inc di
	mov bx,di
	loop put3
	add di,318
	mov bx,di
	mov cx,7
put4:	movsb
	mov si,ax
	mov di,bx
	dec di
	mov bx,di
	loop put4
	mov dx,[si]	
	cmp dl,0
	je blk1
	add [si],byte ptr 72
blk1:	add di,321
	mov bx,di
	mov cx,3
put5:	push cx
	mov cx,6
put6:	movsb
	mov si,ax
	mov di,bx
	inc di
	mov bx,di
	loop put6
	add di,319
	mov bx,di
	mov cx,6
put7:	movsb
	mov si,ax
	mov di,bx
	dec di
	mov bx,di	
	loop put7
	add di,321
	mov bx,di
	pop cx
	loop put5
	mov dx,[si]	
	cmp dl,0
	je blk2
	add [si],byte ptr 72
blk2:	mov cx,7
put8:	movsb
	mov si,ax
	mov di,bx
	inc di
	mov bx,di
	loop put8
	sub di,321
	mov bx,di
	mov cx,6
put9:	movsb
	mov si,ax
	mov di,bx
	sub di,320
	mov bx,di
	loop put9
	inc di
	mov bx,di
	mov cx,9
put10:	movsb
	mov si,ax
	mov di,bx
	add di,320
	mov bx,di
	loop put10
	sub di,321
	mov bx,di
	mov cx,8
put11:	movsb
	mov si,ax
	mov di,bx
	dec di
	mov bx,di
	loop put11
	mov dx,[si]	
	cmp dl,0
	je blk3
	sub [si],byte ptr 144
blk3:	pop di si bx ax
	ret
print_block endp

print_map proc
	push si di
	mov di,10
for_m:	mov si,-1
	add di,10
	cmp di,180
	je done
	lea bx,map
	add bx,di
for_s:	inc si
	cmp si,10
	je for_m
	call print_block
	jmp for_s
done:	pop di si
	ret
print_map endp

put_figure proc
	mov di,cp
	xor si,si
next_b:	xor ax,ax
	mov bx,fig
	mov al,[bx+si]
	shl ax,8
	sar ax,4
	lea bx,map
	add bx,di
	add bl,ah
	xor ah,ah
	sar al,4
	imul m
	add bl,al
	cmp cl,255
	je s_test
	mov [bx],cl
	jmp nex_s
s_test:	cmp [bx],byte ptr 0
	jne no_room
nex_s:	inc si
	cmp si,4
	jne next_b
	call print_map
	jmp put_OK
no_room:xor bx,bx
put_OK:	ret
put_figure endp

shift_possible proc
	push ax bx
	xor dx,dx
	xor cx,cx
	xor si,si
	mov bx,fig
next_p:	xor ax,ax
	mov al,[bx+si]
	shl ax,8
	sar ax,4
	cmp ah,0
	jg right
	cmp dh,ah
	jl down
	mov dh,ah
	jmp down
right:	cmp dl,ah
	jg down
	mov dl,ah
down:	xor ah,ah
	sar al,4
	cmp ch,al
	jg next_s
	mov ch,al
next_s:	inc si
	cmp si,4
	jne next_p
	pop bx ax
	ret
shift_possible endp

shift_figure proc
	call shift_possible
	cmp al,48h
	jne other0
	call rot_figure
	jmp other1
other0:	cmp al,4Bh
	jne other1
	xor ch,ch
	mov ax,cp
	div m
	add ah,dh
	cmp ah,0
	je other1
	mov cl,0
	call put_figure
	mov ax,cp
	dec al
	mov cp,ax
	mov cl,255
	call put_figure
	push bx
	mov bx,fig
	mov cl,[bx+4]
	pop bx
	cmp bx,0
	jne sh_OKd
	mov ax,cp
	inc al
	mov cp,ax
	call put_figure
	jmp other3
other1:	cmp al,4Dh
	jne other2
	xor ch,ch
	mov ax,cp
	div m
	add ah,dl
	cmp ah,9
	je other2
	mov cl,0
	call put_figure
	mov ax,cp
	inc al
	mov cp,ax
	mov cl,255
	call put_figure
	push bx
	mov bx,fig
	mov cl,[bx+4]
	pop bx
	cmp bx,0
	jne sh_OKd
	mov ax,cp
	dec al
	mov cp,ax
sh_OKd:	call put_figure
	jmp other3
other2:	cmp al,50h
	je down1
	jmp other3
down1:	xor ax,ax
	mov al,ch
	mul m
	add ax,cp
	cmp al,170
	jae nex_f
	mov cl,0
	call put_figure
	mov ax,cp
	add al,10
	mov cp,ax
	mov cl,255
	call put_figure
	push bx
	mov bx,fig
	mov cl,[bx+4]
	pop bx
	cmp bx,0
	jne sh_OK
	mov ax,cp
	sub al,10
	mov cp,ax
	call put_figure
nex_f:	call clear_line
	call next_figure
sh_OK:	call put_figure
other3:	ret
shift_figure endp

clear_line proc
	push ax cx si di
	mov di,10
for_m1:	mov si,-1
	add di,10
	cmp di,180
	je done1
	lea bx,map
	add bx,di
for_s1:	inc si
	cmp [bx+si],byte ptr 0
	je for_m1
	cmp si,9
	jne for_s1
	mov ax,lines
	inc ax
	mov lines,ax
	mov ax,score
	add ax,10
	mov score,ax
	mov ax,di
	div m
	xor ah,ah
	mov cx,ax
next_l:	sub bx,10
	xor si,si
next_q:	mov al,[bx+si]
	mov [bx+si+10],al
	inc si
	cmp si,10
	jne next_q
	loop next_l
	jmp for_m1
done1:	mov ax,cp
	div m
	xor ah,ah
	add ax,score
	mov score,ax
	xor dx,dx
	div k
	xor dx,dx
	div k
	xor dx,dx
	div k
	inc ax
	mov level,ax
	dec ax
	mul d_delay
	neg ax
	add ax,18
	mov delay,ax
	mov ax,score
	mov bl,45
	mov ch,3
	mov cl,11
	call output_num
	mov ax,lines
	mov bl,45
	mov ch,5
	mov cl,11
	call output_num
	mov ax,level
	mov bl,45
	mov ch,7
	mov cl,11
	call output_num
	pop di si cx ax
	ret
clear_line endp

rot_possible proc
	push ax
	xor si,si
	mov bx,fig
next_o:	xor ah,ah
	mov al,[bx+si]
	shl ax,8
	sar ax,4
	xor dx,dx
	mov dh,ah
	sar dx,8
	shl ax,8
	sar ax,12
	imul m
	add ax,cp
	add dx,ax
	idiv m
	xchg dx,ax
	idiv m		
	cmp al,dl
	jne bad_r
next_i:	inc si
	xor ah,ah
	cmp si,4
	jne next_o
	jmp rot_OK
bad_r:	mov bx,0
rot_OK:	pop ax
	ret
rot_possible endp

rot_figure proc
	push ax
	mov di,cp
	sub di,20
	mov cl,0
	call put_figure
	xor si,si
next_d:	xor ax,ax
	mov bx,fig
	mov al,[bx+si]
	push bx si
	xor si,si
	lea bx,fr
find:	cmp al,[bx+si]
	jne net_s
	lea bx,to
	mov al,[bx+si]
	pop si bx
	mov [bx+si],al
	inc si
	cmp si,4
	jb next_d
	jmp end_f
net_s:	inc si
	cmp si,12
	jne find
	pop si bx
	cmp si,4
	jae end_f
	inc si
	jmp next_d
end_f:	mov cl,255
	call put_figure
	cmp bx,0
	je rot0
	call rot_possible
	xor si,si
	cmp bx,0
	jne rot1
rot0:	xor ax,ax
	mov bx,fig
	mov al,[bx+si]
	push bx si
	xor si,si
	lea bx,to
find1:	cmp al,[bx+si]
	jne net_s1
	lea bx,fr
	mov al,[bx+si]
	pop si bx
	mov [bx+si],al
	inc si
	cmp si,4
	jb rot0
	jmp rot1
net_s1:	inc si
	cmp si,12
	jne find1
	pop si bx
	cmp si,4
	jae rot1
	inc si
	jmp rot0
rot1:	mov bx,fig
	mov cl,[bx+4]
	call put_figure
	pop ax
	ret	
rot_figure endp

next_figure proc
	push ax
	mov ah,0
	int 1Ah
	push dx
	mov ah,2
	int 1Ah
	pop cx
	mov ax,dx
	xchg al,ah
calc:	add al,ch
	mul ch
	add al,ah
	inc ch
	div ch
	xchg al,ah
	inc ch
	mul ch
	sub al,bh
	add ax,fig
	sub ax,cp
	shl al,5
	shr al,5
	cmp al,7
	je calc
	xor ah,ah
	mul p
	add ax,offset fig1
	cmp ax,fig
	je calc
	mov fig,ax
	mov cp,24
	mov cl,255
	call put_figure
	cmp bx,0
	jne jput1
	call print_go
	mov ah,8
	int 21h
	mov ax,4C00h
	int 21h
jput1:	mov bx,fig
	mov cl,[bx+4]
	pop ax
	ret
	mov cl,255
	call put_figure
	cmp bx,0
	jne jput2
	call print_go
	mov ah,8
	int 21h
	mov ax,4C00h
	int 21h
jput2:	mov bx,fig
	mov cl,[bx+4]
	pop ax
	ret
next_figure endp

print_head proc
	push ax bx cx dx
	mov gc,48
	mov dh,1
	mov dl,4
	mov ah,2
	int 10h
	mov cx,32
	lea bx,head_text
	call output_text
	pop dx cx bx ax
	ret
print_head endp

pause_print proc
	push ax bx cx dx
	mov gc,42
	mov ah,2
	mov dh,12
	mov dl,17
	int 10h
	mov cx,7
	lea bx,pause_text
	call output_text
	pop dx cx bx ax
	ret
pause_print endp

frame_print proc
	push ax bx cx dx
	mov gc,42
	mov ah,2
	mov dh,11
	mov dl,17
	int 10h
	mov cx,7
	lea bx,space1
	call output_text
	mov ah,2
	mov dh,13
	mov dl,17
	int 10h
	mov cx,7
	lea bx,space2
	call output_text
	pop dx cx bx ax
	ret
frame_print endp

print_score proc
	push ax bx cx dx
	mov gc,27
	mov dh,3
	mov dl,0
	mov ah,2
	int 10h
	mov cx,6
	lea bx,score_text
	call output_text
	pop dx cx bx ax
	ret
print_score endp

print_lines proc
	push ax bx cx dx
	mov gc,27
	mov dh,5
	mov dl,0
	mov ah,2
	int 10h
	mov cx,6
	lea bx,lines_text
	call output_text
	pop dx cx bx ax
	ret
print_lines endp

print_level proc
	push ax bx cx dx
	mov gc,27
	mov dh,7
	mov dl,0
	mov ah,2
	int 10h
	mov cx,6
	lea bx,level_text
	call output_text
	pop dx cx bx ax
	ret
print_level endp

print_rot proc
	push ax bx cx dx
	mov gc,27
	mov dh,16
	mov dl,28
	mov ah,2
	int 10h
	mov cx,10
	lea bx,rot_text
	call output_text
	pop dx cx bx ax
	ret
print_rot endp

print_left proc
	push ax bx cx dx
	mov gc,27
	mov dh,17
	mov dl,28
	mov ah,2
	int 10h
	mov cx,8
	lea bx,left_text
	call output_text
	pop dx cx bx ax
	ret
print_left endp

print_right proc
	push ax bx cx dx
	mov gc,27
	mov dh,18
	mov dl,28
	mov ah,2
	int 10h
	mov cx,9
	lea bx,right_text
	call output_text
	pop dx cx bx ax
	ret
print_right endp

print_down proc
	push ax bx cx dx
	mov gc,27
	mov dh,19
	mov dl,28
	mov ah,2
	int 10h
	mov cx,8
	lea bx,down_text
	call output_text
	pop dx cx bx ax
	ret
print_down endp

print_P proc
	push ax bx cx dx
	mov gc,27
	mov dh,21
	mov dl,28
	mov ah,2
	int 10h
	mov cx,9
	lea bx,P_text
	call output_text
	pop dx cx bx ax
	ret
print_P endp

print_quit proc
	push ax bx cx dx
	mov gc,27
	mov dh,22
	mov dl,28
	mov ah,2
	int 10h
	mov cx,8
	lea bx,quit_text
	call output_text
	pop dx cx bx ax
	ret
print_quit endp

print_go proc
	push ax bx cx dx
	mov gc,40
	mov dh,12
	mov dl,16
	mov ah,2
	int 10h
	mov cx,9
	lea bx,go_text
	call output_text
	pop dx cx bx ax
	ret
print_go endp

output_text proc
	push di
	xor di,di
output:	mov ah,0Eh
	mov al,bx[di]
	push bx
	mov bl,gc
	int 10h
	inc dl
	inc di
	mov ah,2
	int 10h
	pop bx
	loop output
	pop di
	ret
output_text endp

output_num proc
div10:	push ax	
	mov dx,cx
	mov ah,2
	int 10h
	dec dl
	mov cx,dx
	pop ax
	xor dx,dx
	div k
	push ax
	mov ax,dx
	add al,30h
	mov ah,0Eh
	int 10h
	pop ax
	cmp al,0
	jne div10
	ret
output_num endp

GO:
	mov ax,@data
	mov ds,ax
	mov ax,0013h
	int 10h
	call print_glass
	call print_head
	call print_score
	call print_lines
	call print_level
	call print_rot
	call print_left
	call print_right
	call print_down
	call print_P
	call print_quit
	mov ax,score
	mov bl,45
	mov ch,3
	mov cl,11
	call output_num
	mov ax,lines
	mov bl,45
	mov ch,5
	mov cl,11
	call output_num
	mov ax,level
	mov bl,45
	mov ch,7
	mov cl,11
	call output_num
	lea bx,fig4
	mov fig,bx
	call next_figure
	mov bx,fig
	mov cl,[bx+4]
	call put_figure
	mov ah,0
	int 1Ah
	add dx,18
	mov time,dx
again:	call shift_figure
read_k:	mov ah,6
	mov dx,00FFh
	int 21h
	cmp al,'p'
	jne go1
	cmp pause,1
	jne set_p
	mov pause,0
	call pause_print
	call frame_print
	jmp again
set_p:	mov pause,1
	call pause_print
	call frame_print
	jmp again
go1:	cmp pause,1
	je read_k
	cmp al,0
	jne go2
	int 21h
	push ax
	mov ah,0
	int 1Ah
	pop ax
	cmp dx,time
	jna again
	add dx,delay
	mov time,dx
	mov al,50h
	jmp again
go2:	cmp al,'q'
	jne again
	mov ax,4C00h
	int 21h
end GO