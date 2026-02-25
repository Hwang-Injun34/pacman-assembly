; =========================================
; 파일명    : player.asm
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
    
    ; y 반환
    add dil, '0' 
    mov [cursor_buf+2], dil 

    mov byte [cursor_buf+3], ';'

    ;x 반환 
    add sil, '0' 
    mov [cursor_buf+4], sil 

    mov byte [cursor_buf+5], 'H' 

    mov rax, SYS_write 
    mov rdi, STDOUT 
    lea rsi, [cursor_buf] 
    mov rdx, CURSOR_LEN
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
;   update_player
;   임시: 오른쪽 이동 테스트
; ====================
update_player:
    inc byte [player_x]
    ret 
    
