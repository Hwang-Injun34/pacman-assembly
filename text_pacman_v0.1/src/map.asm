; =========================================
; 파일명    : map.asm
; 목적      : 게임 맵 데이터를 화면에 출력
; 설명      : 
;   - 좌표 기반으로 맵 그리기 (현재)
; 시작일    : 2026-02-20
; 작성자    :   남궁명수
; ============================

global map_data 
global map_width 
global map_height 
global draw_map 

section .data 
; --------------------
;   상수 정의
; --------------------
LF equ 10       ; line feed 
NULL equ 0     ; end of string

STDOUT equ 1    ; standard output 
SYS_write equ 1 ; write 

; --------------------
;   맵 정의
; --------------------
map_data db \
"##########", LF, \
"#        #", LF, \
"#  ####  #", LF, \
"#        #", LF, \
"#  ####  #", LF, \
"#        #", LF, \
"##########", LF

map_size equ $ - map_data

; --------------------
;   맵 길이
; --------------------
map_width dq 10 
map_height dq 7

section .text 

draw_map:
    ; --------------------
    ;   맵 출력
    ; --------------------
    mov rax, SYS_write
    mov rdi, STDOUT 
    mov rsi, map_data            ; 주소
    mov rdx, map_size            ; 길이
    syscall 
    ret