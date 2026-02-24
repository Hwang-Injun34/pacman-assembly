; =========================================
; 파일명    : game_loop.asm
; 목적      : 메인 루프, 시작점
; 설명      : 
;   - 게임 시작 -> 화면 클리어 -> 플레이어 삽입 -> 맵 출력 -> 입력 처리 -> 이동 처리
;   - ANSI Escape Code 사용 
;   - 플레이어, 고스트, 아이템 위치 표시 (나중)
; 시작일    : 2026-02-22
; 작성자    :   남궁명수
; ============================
global _start 
extern draw_map
extern map_data
extern map_width
extern map_height
extern map_size
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
; --------------------
;   플레이어 위치 계산
; --------------------
calc_index:
    mov rcx, qword [map_width]
    inc rcx
    imul rax, rcx 
    add rax, rbx 
    ret 


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
    ;   플레이어 'P' 삽입
    ; --------------------
    mov rax, qword [player_y]
    mov rbx, qword [player_x]
    call calc_index 
    mov r10, rax 
    mov byte[map_data + r10], 'P'
    
    ; --------------------
    ;   맵 출력
    ; --------------------
    call draw_map 

    ; --------------------
    ;   입력 처리
    ; --------------------
    call read_input 
    mov al, byte [input_char]   ; 연산전에 비트 확장 필수 
    or al, 0x20
    mov r11b, al 
    cmp r11b, 10 
    je game_loop

    ; 임시 좌표로 이동 계산 
    mov rax, qword [player_y]
    mov rbx, qword [player_x]
    
    ; --------------------
    ;   이동 처리(W, A, S, D)
    ; --------------------
    cmp r11b, 'w' 
    je try_up

    cmp r11b, 's' 
    je try_down

    cmp r11b, 'd' 
    je try_right

    cmp r11b, 'a' 
    je try_left 
    
    jmp game_loop


; --------------------
;   W, A, S, D 이동 함수
; --------------------
try_up: 
    cmp rax, 0 
    je game_loop 
    dec rax
    jmp try_move

try_down:
    mov rcx, [map_height]
    dec rcx
    cmp rax, rcx 
    je game_loop
    inc rax
    jmp try_move 


try_right: 
    mov rcx, [map_width]
    dec rcx
    cmp rbx, rcx
    je game_loop
    inc rbx 
    jmp try_move

try_left:
    cmp rbx, 0
    je game_loop
    dec rbx
    jmp try_move 


; --------------------
;   이동 가능한지 체크 하는 함수
; --------------------
try_move:
    ;rax = new_y
    ;rbx = new_x

    push rax  
    push rbx   

    call calc_index 
    mov dl, [map_data + rax]
    cmp dl, '#'
    je cancel_move 

    ; --------------------
    ;   이동 성공
    ; --------------------
    ; 기존 위치 삭제
    mov rax, [player_y]
    mov rbx, [player_x]
    call calc_index
    mov byte [map_data + rax], ' '

    ; 새 좌표 복원
    pop rbx 
    pop rax 

    ; 이동 확정
    mov qword [player_y], rax
    mov qword [player_x], rbx
    jmp game_loop

; --------------------
;   이동 취소
; --------------------
cancel_move:
    pop rbx 
    pop rax 
    jmp game_loop