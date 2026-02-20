; =========================================
; 파일명    : map.asm
; 목적      : 게임 맵 데이터를 화면에 출력
; 설명      : 
;   - 좌표 기반으로 맵 그리기 (현재)
;   - 플레이어, 고스트, 아이템 위치 표시 (나중)
;   - ANSI Escape Code 사용 
; 시작일    : 2026-02-20
; 작성자    :   남궁명수
; ============================

section .data 
LF equ 10       ; line feed 
NULL equ 0     ; end of string

STDOUT equ 1    ; standard output 
STDERR equ 2    ; standard error 

SYS_write equ 1 ; write 
SYS_exit equ 60 ; terminate

clear_screen db 0x1B, '[', 'H', 0x1B, '[', 'J'  ; (커서 이동 + 화면 클리어)
clear_len equ $ - clear_screen

map db "##########", LF 
    db "#        #", LF 
    db "#   p    #", LF 
    db "#        #", LF 
    db "##########", LF 

map_len equ $ - map 

section .text 
global _start

_start: 

    ; 화면 클리어
    mov rax, SYS_write 
    mov rdi, STDOUT 
    mov rsi, clear_screen   ; 주소
    mov rdx, clear_len      ; 길이
    syscall 

    ; 맵 출력
    mov rax, SYS_write
    mov rdi, STDOUT 
    mov rsi, map            ; 주소
    mov rdx, map_len        ; 길이
    syscall 

    ; 종료 
    mov rax, SYS_exit
    xor rdi, rdi            ; exit code 0 
    syscall 


