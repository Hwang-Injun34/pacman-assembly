# 📘 pacman-assembly-project

> x86-64 NASM 어셈블리 기반 Terminal Text Pacman 게임 구현 프로젝트
> 
> 저사양 환경에서 로우레벨 시스템 동작을 이해하고 실전 구현 경험을 쌓기 위한 학습 프로젝트입니다.

---

## 프로젝트 설명

- 주제: x86-64 Assembly 기반 Text Pacman 게임 구현
- 목표:
    - 어셈블리 언어를 활용한 실제 프로그램 구현 경험 확보
    - 시스템 콜 기반 입출력 구조 이해
    - 메모리, 레지스터, 실행 흐름 등 로우레벨 구조 학습
    - 터미널 환경에서의 인터랙티브 프로그램 구현
- 개발 배경:
    - 고수중 언어 중심 개발 환경에서 벗어나 프로그램이 실제 하드웨어 위에서 어떻게 동작하는지 이해하기 위함
    - 제한된 환경에서의 설계 방식과 문제 해결 접근법 체험
- 시스템 구성:
    - 실행 환경:
        - Ubuntu 22.04 x86_64
        - 저사양 데스크탑 (Pentium E5400, 2GB RAM)
    - 개발 도구:
        - NASM(Assembler)
        - ld(Linker)
        - Linux syscall 인터페이스
        - gdb(디버깅)
    - 실행 방식:
        - ELF64 바이너리 직접 생성
        - syscall 기반 입출력 처리
        - 단일 실행 파일 구조

👉 **PDF 문서**  
📄 [Pac-man Assembly Project 보고](./Pac-man Assembly Project 보고서_남궁명수.pdf)

---

## 주요 기능

- 텍스트 기반 맵 출력
- 실시간 키 입력 처리 (Raw Mode)
- 플레이어 이동 (W, A, S, D)
- 벽 충돌 처리
- 점수 시스템 (dot 수집)
- 고스트 랜덤 이동
- 충돌 및 게임 종료 처리
- ANSI Escape Sequence 기반 화면 제어

👉 **PDF 문서**  
📄 ASNI Escape Code

---

## 정리 방식

- 📄 **이론 & 개념**: PDF 파일
- 💻 **실습 & 코드**: GitHub
