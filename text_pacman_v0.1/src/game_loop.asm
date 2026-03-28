; =========================================
; 파일명    : game_loop.asm
; 목적      : 메인 루프, 시작점
; 설명      : 
;   - Raw Mode 활성화
;   - 화면 클리어
;   - 플레이어 삽입
;   - 맵 출력
;   - 입력 처리
;   - 이동 처리 + 벽 충돌
;   - q 누르면 정상 종료
; 시작일    : 2026-02-22
; 작성자    :   남궁명수
; ============================
global main 

extern draw_map
extern draw_score
extern read_input 
extern input_char
extern enable_raw_mode 
extern disable_raw_mode

extern draw_player 
extern erase_player 
extern update_player 
extern player_x 
extern player_y
extern init_dot_count 
extern check_win

extern erase_ghost
extern draw_ghost
extern move_ghost
extern check_ghost_collision
extern check_ghost_cross


section .data 
clear_screen db 27, '[', '2', 'J', 27, '[', 'H'
clear_len equ $ - clear_screen

hide_cursor db 27, '[', '?', '2', '5', 'l'
show_cursor db 27, '[', '?', '2', '5', 'h'
cursor_ctl_len equ 6

STDOUT equ 1 
SYS_write equ 1 	; write 
SYS_exit equ 60 	; terminate 
SYS_nanosleep equ 35

win_msg db 10, "You Win!", 10 
win_msg_len equ $ - win_msg

game_over_msg db 10, "Game Over!", 10
game_over_len equ $ - game_over_msg

; --------------------
; frame delay (100ms)
; --------------------
frame_delay:
    dq 0        ; tv_sec 
    dq 100000000    ; tv_nsec(100ms)


section .text 
main: 
    call enable_raw_mode

    ; --------------------
    ;   커서 숨기기
    ; --------------------
    mov rax, SYS_write 
    mov rdi, STDOUT 
    mov rsi, hide_cursor 
    mov rdx, cursor_ctl_len
    syscall 
    
    ; --------------------
    ;   화면 클리어
    ; --------------------
    mov rax, SYS_write 
    mov rdi, STDOUT
    mov rsi, clear_screen
    mov rdx, clear_len
    syscall 

    ; --------------------
    ;   초기화
    ; --------------------
    call init_dot_count ; Total dot 세기
    call draw_map ; 맵은 1번만 출력
    call draw_player ; 플레이어 최초 출력
    call draw_ghost ; ghost 최초 출력
    call draw_score ; score 최초 출력

; ====================
;   게임 루프
; ====================
game_loop:

    ; --------------------
    ;   입력 읽기
    ; --------------------
    call read_input 
    mov al, byte [input_char] 
    or al, 0x20     ; 대문자 -> 소문자 변환

    cmp al, 'q' ; q 누르면 종료
    je exit_program ; 종료

    ; --------------------
    ;   이전 상태 지우기
    ; --------------------
    call erase_player     ; 플레이어 지우기 
    call erase_ghost        ; 고스트 지우기

    ; --------------------
    ;   이동 처리 + 충돌 검사
    ; --------------------
    call update_player 
    
    call check_ghost_collision 
    test rax, rax 
    jnz game_over

    call check_ghost_cross
    test rax, rax 
    jnz game_over

    ; --------------------
    ;   이동 처리 + 충돌 검사
    ; --------------------
    call move_ghost
    
    call check_ghost_collision 
    test rax, rax 
    jnz game_over

    call check_ghost_cross
    test rax, rax 
    jnz game_over
    
    ; --------------------
    ;   승리 검사
    ; --------------------
    call check_win
    test rax, rax 
    jnz win_program

    ; --------------------
    ;   다시 그리기
    ; --------------------
    call draw_player
    call draw_ghost
    
    call draw_score     ; 점수 갱신

    ; --------------------
    ;   프레임 제한
    ; --------------------
    mov rax, SYS_nanosleep
    mov rdi, frame_delay 
    xor rsi, rsi 
    syscall

    
    jmp game_loop 
; ====================
;   게임 오버
; ====================
game_over:
    call disable_raw_mode

    ; 메시지 출력
    mov rax, SYS_write 
    mov rdi, STDOUT 
    mov rsi, game_over_msg
    mov rdx, game_over_len
    syscall 

    ; 커서 복구
    mov rax, SYS_write 
    mov rdi, STDOUT 
    mov rsi, show_cursor 
    mov rdx, cursor_ctl_len
    syscall 

    mov rax, SYS_exit 
    xor rdi, rdi 
    syscall 

; ====================
;   게임 승리 조건
; ====================
win_program:
    call disable_raw_mode    ; 터미널 복구

    ; 화면 아래에 WIN 출력
    mov rax, SYS_write 
    mov rdi, STDOUT 
    mov rsi, win_msg
    mov rdx, win_msg_len
    syscall 

    ;  커서 다시 보이기
    mov rax, SYS_write 
    mov rdi, STDOUT 
    mov rsi, show_cursor 
    mov rdx, cursor_ctl_len
    syscall 

    mov rax, SYS_exit 
    xor rdi, rdi 
    syscall 


; ====================
;   정상 종료
; ====================   
exit_program:
    call disable_raw_mode
    
    ; --------------------
    ;  커서 다시 보이기
    ; --------------------
    mov rax, SYS_write 
    mov rdi, STDOUT 
    mov rsi, show_cursor 
    mov rdx, cursor_ctl_len
    syscall 

    mov rax, SYS_exit 
    xor rdi, rdi 
    syscall 
