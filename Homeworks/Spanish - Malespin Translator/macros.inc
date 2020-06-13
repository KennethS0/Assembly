section .bss

; ============================
; ==== MACRO DELCLARATION ====
; ============================

; --- PRINTS MESSAGE ON TERMINAL
; %1 : STRING
; %2 : NUMBER OF CHARACTERS
%macro print 2
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


; --- GETS USER INPUT
; %1 : RESERVED MEMORY
; %2 : NUMBER OF BYTES
%macro getInput 2
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

; --- CLEARS RESERVED MEMORY
; %1 : RESERVED MEMORY
; %2 : NUMBER OF BYTES
%macro clear 2
    mov rdi, %1
    mov rcx, %2
    xor rax, rax
    rep stosb
%endmacro


; --- EXIT
%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

; --- #CREATE FILE
; %1 : FILE NAME
%macro createFile 1
    mov rax, SYS_CREATE
    mov rdi, %1
    mov rsi, 0420 ; PERMISSIONS FOR READING, WRITING AND EXECUTING
    syscall
%endmacro


; --- OPEN FILE
; %1 : FILE NAME
; %2 : INSTRUCTION
%macro openFile 2
    mov rax, SYS_OPEN
    mov rdi, %1
    mov rsi, %2
    mov rdx, 0666o   ; PERMISSIONS
    syscall

    push rax
%endmacro


; --- READ FROM FILE
%macro readFile 0
    mov rdi, rax
    mov rax, SYS_READ
    mov rsi, buffer         ; Storage of content
    mov rdx, MAX_FILE_LEN   
    syscall
%endmacro


; --- WRITE TO FILE
; %1 : FILE NAME
%macro writeFile 1

%endmacro

; --- APPENDS TO END OF STRING
; %1 : Reserved memory
; %2 : Character
%macro replaceFinal 2
    mov al, 0
    mov rcx, 0 ; Cleans both registers
    %%_loop:

        mov al, BYTE[%1 + rcx] ; Iterates through each byte
        cmp al, 10             ; Compares with 'Enter' value

        je %%_change 
        
        add rcx, 1
        jmp %%_loop

        %%_change:
            mov BYTE[%1 + rcx], %2

    %%_endloop:
%endmacro 

; --- CLOSE FILE
%macro closeFile 0
    mov rax, SYS_CLOSE
    pop rdi
    syscall
%endmacro
