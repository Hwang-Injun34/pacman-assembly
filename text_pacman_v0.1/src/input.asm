; =========================================
; 파일명    : input.asm
; 목적      : 사용자로부터 이동을 위한 입력 받기
; 설명      : 
;   - W, A, S, D
; 시작일    : 2026-02-22
; 작성자    :   남궁명수
; ============================
global read_input 
global input_char 

section .data 
STDIN equ 0 
SYS_read equ 0 

section .bss 
input_char resb 1 

section .text 

read_input:
    ; --------------------
    ;   입력 받기
    ; --------------------
    mov rax, SYS_read 
    mov rdi, STDIN          ; standard input
    mov rsi, input_char 
    mov rdx, 1 
    syscall 
    ret 
