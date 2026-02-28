; =========================================
; 파일명    : player.asm(2자리 숫자 좌표 변환 루틴 구현)
; 목적      : 플레이어 렌더링 + 좌표 관리
; 설명      : 
;   - 이동을 위한 좌표
;   - 맵, 방해물 등등 요소를 고려해야함
; 시작일    : 2026-02-22
; 작성자    :   남궁명수
; ============================
global draw_player 
global erase_player 
global update_player 
global player_x 
global player_y

extern input_char 
extern map_data 
extern map_width 
extern map_height

section .data 
player_char db 'P'
space_char db ' '

; 좌표는 0~9 가정(한 자리 숫자)
player_x db 2
player_y db 2

STDOUT equ 1 
SYS_write equ 1 	; write 
CURSOR_LEN equ 6    ; ESC[y;xH

section .bss
cursor_buf resb 16

section .text 

; ====================
;   move_cursor(y, x) : ANSI Escape Code를 활용한 커서 이동
;   rdi = y (0~9)
;   rsi = x (0~9) 
; ====================
move_cursor:
    mov byte [cursor_buf], 27   ;ESC 
    mov byte [cursor_buf+1], '[' 
    
    ; y 
    mov rax, rdi 
    mov rbx, 10 
    xor rdx, rdx 
    div rbx         ; rax=십의 자리, rdx=일의 자리
    
    mov rcx, 2      ; 현재 버퍼 인덱스
    
    cmp rax, 0      ; 십의 자리(몫)이 0이면 
    je .skip_y_tens ; skip_y_tens로 이동
    add al, '0'     ; 십의 자리(몫)이 0이 아니면 
    mov [cursor_buf+rcx], al 
    inc rcx 

.skip_y_tens:
    add dl, '0'     ; 나머지 값을 ASCII 값으로 저장
    mov [cursor_buf+rcx], dl
    inc rcx 

    mov byte [cursor_buf+rcx], ';'
    inc rcx 

    ; --------------------
    ;   x 처리
    ; --------------------
    mov rax, rsi 
    mov rbx, 10 
    xor rdx, rdx 
    div rbx 

    cmp rax, 0 
    je .skip_x_tens 
    add al, '0' 
    mov [cursor_buf+rcx], al  
    inc rcx 

.skip_x_tens: 
    add dl, '0' 
    mov [cursor_buf+rcx], dl 
    inc rcx 

    mov byte [cursor_buf+rcx], 'H' 
    inc rcx 

    mov rax, SYS_write 
    mov rdi, STDOUT 
    lea rsi, [cursor_buf]
    mov rdx, rcx 
    syscall 
    ret


; ====================
;   draw_player(y, x) : 플레이어 그리기
;   rdi = y 
;   rsi = x  
; ====================
draw_player: 
    movzx rdi, byte [player_y]
    movzx rsi, byte [player_x]
    call move_cursor    ; 해당 좌표로 커서 이동

    mov rax, SYS_write
    mov rdi, STDOUT 
    lea rsi, [player_char]
    mov rdx, 1
    syscall 
    ret 

; ====================
;   erase_player : 이전 플레이어 위치 삭제
;   rdi = y 
;   rsi = x  
; ====================
erase_player:
    movzx rdi, byte [player_y]
    movzx rsi, byte [player_x]
    call move_cursor 

    mov rax, SYS_write
    mov rdi, STDOUT
    lea rsi, [space_char]
    mov rdx, 1 
    syscall 
    ret 

; ====================
;   calc_index : 플레이어 위치 계산
;   rax = y 
;   rbx = x 
; ==================
calc_index:
    mov rcx, qword [map_width]
    inc rcx 
    imul rax, rcx 
    add rax, rbx 
    ret 

; ====================
;   update_player
;   w, a, s, d
; ====================
update_player:

    ; 현재 좌표 
    movzx rax, byte [player_y]
    movzx rbx, byte [player_x]

    ; 입력 읽기
    mov cl, [input_char]
    or cl, 0x20

    cmp cl, 'w' 
    je try_up 

    cmp cl, 's' 
    je try_down 

    cmp cl, 'a' 
    je try_left 

    cmp cl, 'd' 
    je try_right 
    ret 

try_up: 
    cmp rax, 0 
    je done 
    dec rax 
    jmp check_wall 

try_down:
    mov rcx, qword [map_height]
    dec rcx 
    cmp rax, rcx 
    je done 
    inc rax 
    jmp check_wall 

try_left: 
    cmp rbx, 0
    je done 
    dec rbx 
    jmp check_wall 

try_right:
    mov rcx, qword [map_width]
    dec rcx 
    cmp rbx, rcx 
    je done 
    inc rbx 
    jmp check_wall

; ====================
;   check_wall : 벽 검사
; ====================
check_wall:
    push rax 
    push rbx 

    call calc_index 
    mov dl, [map_data + rax] 
    cmp dl, '#' 
    je cancel_move

    pop rbx 
    pop rax 
    
    mov [player_y], al 
    mov [player_x], bl 
    ret 


; ====================
;   이동 취소
; ====================
cancel_move: 
    pop rbx 
    pop rax 

; ====================
;   종료
; ====================
done: 
    ret