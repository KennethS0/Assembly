section .data
    msgTranslationChoice db "Digite el numero correspondiente: ", 10, "(0) Espanol -> Malespin", 10, "(1) Malespin -> Espanol", 10
    msgTranslationChoiceLen equ $-msgTranslationChoice

    msgReadingChoice db "Digite el numero correspondiente:", 10, "(0) Leer de terminal.", 10, "(1) Leer de archivo.", 10
    msgReadingChoiceLen equ $-msgReadingChoice

section .bss
    translationChoice resb 2
    readingChoice resb 2

section .text
; ============================
; ==== MACRO DELCLARATION ====
; ============================

; --- PRINTS MESSAGE ON TERMINAL
; %1 : STRING
; %2 : NUMBER OF CHARACTERS
%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


; --- GETS USER INPUT
; %1 : RESERVED MEMORY
; %2 : NUMBER OF BYTES
%macro getInput 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


; --- EXIT
%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro


; ============================
; ===    MAIN   PROGRAM    ===
; ============================
global _start

_start:
    ; USER INTERACTION
    print msgTranslationChoice, msgTranslationChoiceLen
    getInput translationChoice, 2

    print msgReadingChoice, msgReadingChoiceLen
    getInput readingChoice, 2

    ; READING AND TRANSLATING

    ; WRITING

    exit
