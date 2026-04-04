# 📁 pacman-assembly-project

> x86-64 NASM 어셈블리 기반 Terminal Text Pacman 게임 구현 프로젝트<br>
> 시스템 콜, 메모리, 레지스터 수준에서 프로그램 동작을 직접 제어하며<br>
> 로우레벨 시스템 이해를 목표로 한 프로젝트

---

## 🧾 프로젝트 정보
- 프로젝트 형태: 개인 프로젝트(로우레벨 시스템 이해 및 어셈블리 기반 프로그램 구현)
- 개발 기간: 2026.02 ~ 2026.03
- 결과:  <br>
    - x86-64 NASM 기반 Terminal Pacman 게임 구현
    - Linux syscall을 활용한 입출력 처리 구조 직접 구현
    - 레지스터 및 메모리 기반 게임 로직 설계
    - ANSI Escape Sequence를 활용한 터미널 화면 제어 구현
    - 고수준 언어 없이 인터랙티브 프로그램 구현 경험 확보

📄 **PDF 문서**  
- [Pac-man Assembly Project 보고서](https://github.com/Hwang-Injun34/pacman-assembly/blob/main/Pac-man%20Assembly%20Project%20%E1%84%87%E1%85%A9%E1%84%80%E1%85%A9%E1%84%89%E1%85%A5_%E1%84%82%E1%85%A1%E1%86%B7%E1%84%80%E1%85%AE%E1%86%BC%E1%84%86%E1%85%A7%E1%86%BC%E1%84%89%E1%85%AE.pdf)

---

## 📌 프로젝트 개요
이 프로젝트는 x86-64 Assembly(NASM)를 활용하여<br>
터미널 환경에서 동작하는 Pacman 게임을 직접 구현한 프로젝트입니다.

고수준 언어를 사용하지 않고, <br>
Linux 시스템 콜을 기반으로 입출력, 메모리 제어, 실행 흐름을 직접 다루며 <br>
프로그램이 하드웨어 위에서 어떻게 동작하는지를 이해하는 데 목적을 두었습니다.

또한, 제한된 환경에서 인터랙티브 프로그램을 구현함으로써<br>
로우레벨 설계 능력과 문제 해결 능력 향상을 목표로 진행되었습니다.

---

## 🎯 프로젝트 목표
- Assembly 기반 실제 프로그램 구현 경험 확보
- Linux syscall 기반 입출력 구조 이해
- 레지스터 / 메모리 / 스택 구조 확인
- 고수준 언어 없이 게임 로직 직접 구현
- 터미널 기반 인터랙티브 프로그램 개발

---

## ⚙️ 시스템 구성
### 실행 환경
- Ubuntu 22.04 x86_64
- 저사양 데스크탑 (Pentium E5400, 2GB RAM)

### 개발 도구:
- NASM(Assembler)
- ld(Linker)
- Linux syscall 인터페이스
- gdb(디버깅)

### 실행 방식:
- ELF64 바이너리 직접 생성
- syscall 기반 입출력 처리
- 단일 실행 파일 구조


---

## 🧩 주요 기능
- 텍스트 기반 맵 출력
- 실시간 키 입력 처리 (Raw Mode)
- 플레이어 이동 (W, A, S, D)
- 벽 충돌 처리
- 점수 시스템 (dot 수집)
- 고스트 랜덤 이동
- 충돌 및 게임 종료 처리
- ANSI Escape Sequence 기반 화면 렌더링

📄 **PDF 문서**  
- [ANSI Escape Code](https://github.com/Hwang-Injun34/pacman-assembly/blob/main/ASNI%20Escape%20Code_%E1%84%82%E1%85%A1%E1%86%B7%E1%84%80%E1%85%AE%E1%86%BC%E1%84%86%E1%85%A7%E1%86%BC%E1%84%89%E1%85%AE.pdf)

---

## 🕹️ 실행 화면
- 추가 예정


---

## 🗂 정리 방식

- 📄 **이론 & 개념, 보고서**: PDF
- 🔗 **실습 & 코드**: GitHub
