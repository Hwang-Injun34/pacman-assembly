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
extern read_input 
extern input_char
extern enable_raw_mode 
extern disable_raw_mode

extern draw_player 
extern erase_player 
extern update_player 
extern player_x 
extern player_y


section .data 
clear_screen db 27, '[', '2', 'J', 27, '[', 'H'
clear_len equ $ - clear_screen

STDOUT equ 1 
SYS_write equ 1 	; write 
SYS_exit equ 60 	; terminate 

section .text 
main: 
    call enable_raw_mode
    
    ; --------------------
    ;   화면 클리어
    ; --------------------
    mov rax, SYS_write 
    mov rdi, STDOUT
    mov rsi, clear_screen
    mov rdx, clear_len
    syscall 

    ; --------------------
    ;   맵은 1번만 출력
    ; --------------------
    call draw_map

    ; --------------------
    ;   플레이어 최초 출력
    ; --------------------
    call draw_player

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
    mov r11b, al 

    ; q 누르면 종료
    cmp r11b, 'q' 
    je exit_program

    ; 플레이어 지우기 
    call erase_player 

    ; 이동 처리(현재 오른쪽만)
    call update_player 

    ; 다시 그리기
    call draw_player
    
    jmp game_loop 

; ====================
;   정상 종료
; ====================   
exit_program:
    call disable_raw_mode

    mov rax, SYS_exit 
    xor rdi, rdi 
    syscall 



