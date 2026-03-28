; =========================================
; 파일명    : ghost.asm
; 목적      : Ghost(적) 시스템
; 설명      : 
;   - 화면에 G 표시
;   - 일정 시간마다 이동
;   - 플레이어랑 충돌하면 game over
; 시작일    : 2026-03-08
; 작성자    :   남궁명수
; ============================
global erase_ghost
global move_ghost 
global draw_ghost
global check_ghost_collision
global check_ghost_cross

extern move_cursor
extern player_x   
extern player_y

extern map_data 
extern map_width
extern map_height

section .data 
ghost_x db 4        ; 현재 위치
ghost_y db 3       


ghost_prev_x db 4 ; 이전 위치
ghost_prev_y db 3 ; 이전 위치
ghost_prev_char db ' ' ; 이전 위치 문자 (초기 공백)

ghost_char db 'G'   ; 출력할 문자

STDOUT equ 1 
SYS_write equ 1 	; write 

section .text 

; --------------------
;   ghost 이동
; --------------------
draw_ghost:
    ; 현재 위치 문자 저장
    mov al, [ghost_y]
    mov bl, [ghost_x]
    call get_map_char
    mov [ghost_prev_char], al

    ; 현재 좌표도 저장
    mov al, [ghost_x]
    mov [ghost_prev_x], al

    mov al, [ghost_y]
    mov [ghost_prev_y], al

    ; 출력
    movzx rdi, byte [ghost_y]
    movzx rsi, byte [ghost_x]
    call move_cursor 

    mov rax, SYS_write
    mov rdi, STDOUT 
    mov rsi, ghost_char
    mov rdx, 1 
    syscall 
    ret

; --------------------
;   ghost 지우기 (이전 위치 복구)
; --------------------
erase_ghost:
    movzx rdi, byte [ghost_prev_y]
    movzx rsi, byte [ghost_prev_x]
    call move_cursor

    mov rax, SYS_write
    mov rdi, STDOUT 
    lea rsi, [ghost_prev_char]
    mov rdx, 1 
    syscall
    ret

; --------------------
;   ghost 이동(랜덤 + 벽 체크)
; --------------------  
move_ghost: 

    ; --------------------
    ; 이전 위치 + 문자 저장
    ; --------------------
    mov al, [ghost_x]
    mov [ghost_prev_x], al

    mov al, [ghost_y]
    mov [ghost_prev_y], al

    mov al, [ghost_prev_y]
    mov bl, [ghost_prev_x]
    call get_map_char
    mov [ghost_prev_char], al

    ; --------------------
    ; 랜덤 방향 선택
    ; --------------------
    rdtsc           ; CPU 시간 기반 값
    shr eax, 3
    and eax, 3 

    cmp eax, 0 
    je ghost_up 

    cmp eax, 1 
    je ghost_down 

    cmp eax, 2 
    je ghost_left 

    jmp ghost_right 

; --------------------
; 이동 로직 (벽 체크 포함)
; --------------------
ghost_up:
    mov al, [ghost_y]
    mov bl, [ghost_x]

    mov dl, al
    dec dl

    movzx rax, dl
    movzx rbx, bl

    call is_wall
    cmp al, 1
    je done

    dec byte [ghost_y]
    jmp done

ghost_down:
    mov al, [ghost_y]
    mov bl, [ghost_x]

    mov dl, al
    inc dl            ; 다음 y

    movzx rax, dl
    movzx rbx, bl

    call is_wall      ; 결과: al

    cmp al, 1
    je done

    inc byte [ghost_y]
    jmp done

ghost_left:
    mov al, [ghost_y]
    mov bl, [ghost_x]

    mov dl, bl
    dec dl

    movzx rax, al
    movzx rbx, dl

    call is_wall
    cmp al, 1
    je done

    dec byte [ghost_x]
    jmp done

ghost_right:
    mov al, [ghost_y]
    mov bl, [ghost_x]

    mov dl, bl
    inc dl

    movzx rax, al
    movzx rbx, dl

    call is_wall
    cmp al, 1
    je done

    inc byte [ghost_x]


done:
    ret

; --------------------
; 플레이어 충돌 검사
; --------------------
check_ghost_collision:
    movzx rax, byte [ghost_x]
    movzx rbx, byte [player_x]
    cmp rax, rbx
    jne no_hit 

    movzx rax, byte [ghost_y]
    movzx rbx, byte [player_y]
    cmp rax, rbx 
    jne no_hit 

    mov rax, 1
    ret 

no_hit:
    xor rax, rax 
    ret

check_ghost_cross:
    ; 이전 위치 비교
    movzx rax, byte [ghost_prev_x]
    movzx rbx, byte [player_x]
    cmp rax, rbx
    jne .no

    movzx rax, byte [ghost_prev_y]
    movzx rbx, byte [player_y]
    cmp rax, rbx
    jne .no

    mov rax, 1
    ret

.no:
    xor rax, rax
    ret



; --------------------
; 벽 체크
; input:  al=y, bl=x
; output: al=1(벽), 0(길)
; --------------------
is_wall:
    movzx rax, al
    movzx rbx, bl

    mov rcx, [map_width]
    add rcx, 1          ; LF 포함

    imul rax, rcx
    add rax, rbx

    mov rdx, map_data
    add rdx, rax

    mov al, [rdx]

    cmp al, '#'
    je .wall

    xor al, al
    ret

.wall:
    mov al, 1
    ret




; --------------------
; 맵 문자 읽기
; --------------------
get_map_char:
    movzx rax, al
    movzx rbx, bl

    mov rcx, [map_width]
    add rcx, 1

    imul rax, rcx
    add rax, rbx

    mov rdx, map_data
    add rdx, rax

    mov al, [rdx]
    ret