; =========================================
; 파일명    : terminal.asm
; 목적      : Raw Mode 설정 파일
; 설명      :
;   - libc를 활용(직접 다 구현하기엔 실력 x)
;       - tcgetattr
;       - tcsetattr
;   - ld가 아닌 gcc 사용
;   - 사용자의 입력을 즉시 반응하기 위함
; 시작일    : 2026-02-24
; 작성자    :   남궁명수
; ============================
global enable_raw_mode 
global disable_raw_mode 

extern tcgetattr 
extern tcsetattr

section .bss 
old_termios resb 60 ; 원본
new_termios resb 60 ; 복사본

section .text 
; --------------------
;   enable_raw_mode 
;   터미널을 raw 모드로 변경
; --------------------
enable_raw_mode: 
    ; tcgetattr(0, &old_termios)
    mov rdi, 0              ; fd = 0
    mov rsi, old_termios
    call tcgetattr 

    ; new_termios = old_termios 복사 
    mov rcx, 60 ; 반복 횟수 설정
    mov rsi, old_termios 
    mov rdi, new_termios 

    .copy: 
        mov al, [rsi]   ; old_termios 1바이트 읽기
        mov [rdi], al   ; new_termios에 저장
        inc rsi         ; 다음 바이트
        inc rdi 
        loop .copy      ; rcx-- 후 0이 아니면 반복

    ; ICANON(0x0002) + ECHO(0x0008) 끄기
    ; c_lflag offset = 12 (glibc x86-64 기준)
    mov eax, [new_termios + 12]
    and eax, ~0x000A 
    mov [new_termios + 12], eax 

    ; tcsetattr(0, TCSANOW=0, &new_termios)
    mov rdi, 0 
    mov rsi, 0 
    mov rdx, new_termios 
    call tcsetattr 

    ret 

; ---------------------------------
; disable_raw_mode
; ---------------------------------
disable_raw_mode: 
    mov rdi, 0 
    mov rsi, 0
    mov rdx, old_termios 
    call tcsetattr
    ret

