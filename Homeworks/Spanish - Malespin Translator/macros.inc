section .bss

digitSpace resb 100
digitSpacePos resb 8

    ; --- FILE MANAGEMENT
descriptor resb 4
buffer resb MAX_FILE_LEN

    ; --- USER INTERACTION
translationChoice resb CHOICE_SIZE
readingChoice resb CHOICE_SIZE
retryChoice resb CHOICE_SIZE

FILE_NAME resb FILE_PATH_SIZE

MESSAGE resb MAX_USER_INPUT

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

; --- OPEN FILE
; %1 : FILE NAME
; %2 : INSTRUCTION
%macro openFile 2
    mov rax, SYS_OPEN
    mov rdi, %1
    mov rsi, %2
    mov rdx, 0644o   ; PERMISSIONS
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
; % 1 : TEXT
; % 2 : LENGTH OF TEXT
%macro writeFile 2
    mov rdi, rax      ; FIle Descriptor
    mov rax, SYS_WRITE
    mov rsi, %1
    mov rdx, %2
    syscall
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

; --- CHANGES CHARACTERS FROM A STRING
; %1 : String
; %2 : Array of characters to change
; %3 : Array of characters of the new string
; %4 : Register holding the file size
%macro translate 5
    ; ---=== COUNTERS ===---
    ; R12 : LETTERS
    ; R13 : CHANGED LETTERS
    ; R14 : WORDS
    ; R15 : CHANGED WORDS
    ; RCX : POINTER
    xor rcx, rcx        ; Cleans registers
    xor r12, r12
    xor r13, r13
    xor r14, r14
    xor r15, r15
    xor rbx, rbx

    %%_newCharacterLoop:
        cmp rcx, %4
        jg %%_exit  ; Checks if RCX is greater than the file size

        mov al, BYTE[%1 + rcx] ; New character to check
        mov BYTE[%5 + rcx], al

        ; --- LETTER VALIDATION
        cmp al, 'A'
        jl %%_increment

        cmp al, 'z'
        jg %%_increment

        cmp al, 'Z'
        jle %%_addLetter

        cmp al, 'a'
        jge %%_addLetter

    %%_addLetter:
        inc r12
        cmp rcx, %4
        je %%_lookUpLoop ; Checks for last letter

    %%_checkNext:
        mov bl, BYTE[%1 + rcx + 1]

        cmp bl, 'A'
        jl %%_newWord

        cmp bl, 'z'
        jg %%_newWord

        cmp bl, 'Z'
        jle %%_lookUpLoop

        cmp bl, 'a'
        jge %%_lookUpLoop

        jmp %%_newWord

    %%_newWord:
        inc r14 ; Increments word count

    %%_lookUpLoop:    
        xor r9, r9
        xor bl, bl
        %%_loop:
            cmp r9, LOOK_UP_LEN
            jg %%_endloop

            mov bl, BYTE[%2 + r9]

            cmp al, bl
            je %%_swap

            inc r9
            jmp %%_loop

            %%_swap:
                mov bl, BYTE[%3 + r9]
                mov BYTE[%5 + rcx], bl

        %%_endloop:
            xor r9, r9
            xor bl, bl

    %%_increment:
        inc rcx
        jmp %%_newCharacterLoop    

    %%_exit:
%endmacro

; --- GETS THE LENGTH OF A STRING FROM CONSOLE
; %1 : String
; %2 : Register where the length is saved
%macro getLen 2
    xor %2, %2
    xor rcx, rcx

    %%_xloop:

        mov al, BYTE[%1 + rcx]

        cmp al, 10
        jmp %%_end

        inc rcx
        jmp %%_xloop
    
    %%_end:
        mov %2, rcx
%endmacro

; --- GET FILE SIZE
%macro getFileSize 0
    mov rdi, rax
    mov rax, SYS_LSEEK
    mov rsi, 0
    mov rdx, 2
    syscall
%endmacro


;--This was used for debugging purposes
; --- PRINT RAX
%macro printRax 0
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx

    %%_printRAXLoop:
        mov rdx, 0
        mov rbx, 10
        div rbx
        push rax
        add rdx, 48

        mov rcx, [digitSpacePos]
        mov [rcx], dl
        inc rcx
        mov [digitSpacePos], rcx
        
        pop rax
        cmp rax, 0
        jne %%_printRAXLoop

    %%_printRAXLoop2:
        mov rcx, [digitSpacePos]

        mov rax, 1
        mov rdi, 1
        mov rsi, rcx
        mov rdx, 1
        syscall

        mov rcx, [digitSpacePos]
        dec rcx
        mov [digitSpacePos], rcx

        cmp rcx, digitSpace
        jge %%_printRAXLoop2
%endmacro


; --- CLOSE FILE
%macro closeFile 0
    mov rax, SYS_CLOSE
    pop rdi
    syscall
%endmacro