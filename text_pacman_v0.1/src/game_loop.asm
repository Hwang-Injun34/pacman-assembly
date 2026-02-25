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
extern map_data
extern map_width
extern map_height
extern map_size
extern read_input 
extern input_char
extern player_x 
extern player_y
extern enable_raw_mode 
extern disable_raw_mode

section .data 
; clear_screen db 27, '[', '2', 'J', 27, '[', 'H'
; clear_screen db 0x1B, '[', 'H', 0x1B, '[', 'J'  
; clear_len equ $ - clear_screen
cursor_home db 27, '[', 'H' 
cursor_len equ $ - cursor_home

LF equ 10 
STDIN equ 0 
STDOUT equ 1 

SYS_read equ 0 	     ; read 
SYS_write equ 1 	; write 
SYS_exit equ 60 	; terminate 

section .text 
; ====================
;   플레이어 위치 계산
;   rax = y 
;   rbx = x 
;   반환: rax = index 
; ====================
calc_index:
    mov rcx, qword [map_width]
    inc rcx     ; LF 포함
    imul rax, rcx 
    add rax, rbx 
    ret 


main: 
    call enable_raw_mode

game_loop:
    ; --------------------
    ;   화면 클리어
    ; --------------------
    mov rax, SYS_write 
    mov rdi, STDOUT
    mov rsi, cursor_home
    mov rdx, cursor_len
    syscall 
    
    ; --------------------
    ;   플레이어 'P' 삽입
    ; --------------------
    mov rax, qword [player_y]
    mov rbx, qword [player_x]
    call calc_index 
    mov byte[map_data + rax], 'P'
    
    ; --------------------
    ;   맵 출력
    ; --------------------
    call draw_map 

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


    ; --------------------
    ;   이동 계산용 현재 좌표 복사
    ; --------------------
    mov rax, qword [player_y]
    mov rbx, qword [player_x]
    
    ; --------------------
    ;   방향 판별 (W, A, S, D)
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


; ====================
;   이동 시도
; ====================
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


; ====================
;   벽 충돌 검사
;   rax = new_y 
;   rbx = new_x
; ====================
try_move:
    ; new 좌표 백업
    push rax  
    push rbx   

    ; index 계산
    call calc_index 

    ; 벽 검사
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


; ====================
;   이동 취소
; ====================
cancel_move:
    pop rbx 
    pop rax 
    jmp game_loop

; ====================
;   정상 종료
; ====================
exit_program:
    call disable_raw_mode
    
    mov rax, SYS_exit 
    xor rdi, rdi  ; 이거 왜 해주는지 아직 모름, 문서 확인하기
    syscall 