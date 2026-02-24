; =========================================
; 파일명    : player.asm
; 목적      : 플레이어 좌표
; 설명      : 
;   - 이동을 위한 좌표
;   - 맵, 방해물 등등 요소를 고려해야함
; 시작일    : 2026-02-22
; 작성자    :   남궁명수
; ============================
global player_y
global player_x 

section .data 
player_y dq 1
player_x dq 1