; =========================================
; 파일명    : game_loop.asm
; 목적      : 메인 루프, 시작점
; 설명      : 
;   - (향후 게임의 전체적인 로직 작성)
;   - ANSI Escape Code 사용 
;   - 플레이어, 고스트, 아이템 위치 표시 (나중)
; 시작일    : 2026-02-22
; 작성자    :   남궁명수
; ============================
global _start 
extern print_map
extern read_input 
extern input_char
extern player_x 
extern player_y

section .data 
clear_screen db 27, '[', '2', 'J', 27, '[', 'H'
; clear_screen db 0x1B, '[', 'H', 0x1B, '[', 'J'  
clear_len equ $ - clear_screen

LF equ 10 
STDIN equ 0 
STDOUT equ 1 
STDERR equ 2 

SYS_read equ 0 	     ; read 
SYS_write equ 1 	; write 
SYS_exit equ 60 	; terminate 
SYS_create equ 85	; file open/create 
SYS_time equ 201	; get time 

section .bss 

section .text 
_start: 
game_loop:
    ; --------------------
    ;   화면 클리어
    ; --------------------
    mov rax, SYS_write 
    mov rdi, STDOUT
    mov rsi, clear_screen 
    mov rdx, clear_len
    syscall 

    ; --------------------
    ;   맵 출력
    ; --------------------
    call print_map 

    ; --------------------
    ;   입력 읽기
    ; --------------------
    call read_input 
    mov al, byte [input_char]   ; 연산전에 비트 확장 필수 
    or al, 0x20
    
    ; --------------------
    ;   이동 처리(W, A, S, D)
    ; --------------------
    cmp al, 'w' 
    je move_up

    cmp al, 's' 
    je move_down

    cmp al, 'd' 
    je move_right

    cmp al, 'a' 
    je move_left 
    
    jmp game_loop


move_up: 
    dec byte [player_y]
    jmp game_loop

move_down:
    inc byte [player_y]
    jmp game_loop

move_right: 
    inc byte [player_x]
    jmp game_loop

move_left:
    dec byte [player_x]
    jmp game_loop